//
//  Copyright 2011  U.S. Centers for Disease Control and Prevention
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software 
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "CdaWriter.h"
#import <libxml/xmlwriter.h>
#import <libxml/encoding.h>

@implementation CdaWriter


- (xmlChar *) xmlCharPtrForInput:(const char *)_input withEncoding:(const char *)_encoding 
{
    xmlChar *_output;
    int _ret;
    int _size;
    int _outputSize;
    int _temp;
    xmlCharEncodingHandlerPtr _handler;
    
    if (_input == 0)
        return 0;
    
    _handler = xmlFindCharEncodingHandler(_encoding);
    
    if (!_handler) {
        NSLog(@"convertInput: no encoding handler found for '%s'\n", (_encoding ? _encoding : ""));
        return 0;
    }
    
    _size = (int) strlen(_input) + 1;
    _outputSize = _size * 2 - 1;
    _output = (unsigned char *) xmlMalloc((size_t) _outputSize);
    
    if (_output != 0) {
        _temp = _size - 1;
        _ret = _handler->input(_output, &_outputSize, (const xmlChar *) _input, &_temp);
        if ((_ret < 0) || (_temp - _size + 1)) {
            if (_ret < 0) {
                NSLog(@"convertInput: conversion wasn't successful.\n");
            } else {
                NSLog(@"convertInput: conversion wasn't successful. Converted: %i octets.\n", _temp);
            }   
            xmlFree(_output);
            _output = 0;
        } else {
            _output = (unsigned char *) xmlRealloc(_output, _outputSize + 1);
            _output[_outputSize] = 0;  /*null terminating out */
        }
    } else {
        NSLog(@"convertInput: no memory\n");
    }
    
    return _output;
}

- (NSData *) xmlDataFromRequest 
{
    xmlTextWriterPtr _writer;
    xmlBufferPtr _buf;
    xmlChar *_tmp;
    const char *_UTF8Encoding = "UTF-8";
    
    _buf = xmlBufferCreate();
    _writer = xmlNewTextWriterMemory(_buf, 0);
    
    // <?xml version="1.0" encoding="UTF-8"?>
    xmlTextWriterStartDocument(_writer, "1.0", _UTF8Encoding, NULL);
    
    // <request type="handle" action="update">
    //<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:hl7-org:v3 Y:/Alschuler/greenCLIP/CDA/infrastructure/cda/CDA.xsd">
    xmlTextWriterStartElement(_writer, BAD_CAST "ClinicalDocument");
    
    xmlTextWriterWriteAttribute(_writer, BAD_CAST "type", BAD_CAST "handle");
    xmlTextWriterWriteAttribute(_writer, BAD_CAST "action", BAD_CAST "update");
    xmlTextWriterEndElement(_writer);
    
    // <userdata>...</userdata>
    xmlTextWriterStartElement(_writer, BAD_CAST "userdata");
    xmlTextWriterStartElement(_writer, BAD_CAST "username");
    _tmp = [self xmlCharPtrForInput:[[NSString stringWithFormat:@"YourUsername"] cStringUsingEncoding:NSUTF8StringEncoding] withEncoding:_UTF8Encoding];
    xmlTextWriterWriteString(_writer, _tmp);
    xmlTextWriterEndElement(_writer); // closing <username>
    xmlFree(_tmp);
    xmlTextWriterStartElement(_writer, BAD_CAST "password");
    _tmp = [self xmlCharPtrForInput:[[NSString stringWithFormat:@"YourPassword"] cStringUsingEncoding:NSUTF8StringEncoding] withEncoding:_UTF8Encoding];
    xmlTextWriterWriteString(_writer, _tmp);
    xmlTextWriterEndElement(_writer); // closing <password>
    xmlFree(_tmp); 
    xmlTextWriterEndElement(_writer); // closing <userdata>
    
    // etc.
    
    xmlTextWriterEndDocument(_writer);
    xmlFreeTextWriter(_writer);
    
    // turn libxml2 buffer into NSData* object
    
    NSData *_xmlData = [NSData dataWithBytes:(_buf->content) length:(_buf->use)];
    xmlBufferFree(_buf);
    
    return _xmlData;
}

@end
