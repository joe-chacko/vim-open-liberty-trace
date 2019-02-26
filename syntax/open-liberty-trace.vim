" Copyright (c) 2019 IBM Corporation and others.
" All rights reserved. This program and the accompanying materials
" are made available under the terms of the Eclipse Public License v1.0
" which accompanies this distribution, and is available at
" http://www.eclipse.org/legal/epl-v10.html
"
" Contributors:
"     IBM Corporation - initial implementation

" Vim syntax file
" Language:	Liberty trace
" Filenames:	trace*.log

" Start by clearing out any old definitions
syntax clear

" Ignore case differences
syn case ignore

" Define the standard Liberty trace line
" [timestamp] thread objectid component loglevel [trace msg key: ]text
syn match olTimestamp	/\v^\[[^\]]*\]/									nextgroup=olThread	skipwhite
" match the thread id and expect the object id next
syn match olThread	/\v\x{8}/				contained				nextgroup=olObjectId	skipwhite
" match the thread id NOT FOLLOWED BY object id (default messages.log format)
syn match olThread	/\v\x{8} (id\=.{8} )@!/			contained				nextgroup=olComponent	skipwhite
syn match olObjectId	/\vid=[^ ]*/				contained				nextgroup=olComponent	skipwhite
syn match olComponent	/\v[^ ]+/				contained				nextgroup=olLogLevel	skipwhite
" match log level as a single character
syn match olLogLevel	/\v[^ ]/				contained				nextgroup=olText	skipwhite
" alternatively, match log level as a single character followed by a msg id
syn match olLogLevel	/\vI +[A-Z0-9]{2,5}[0-9]{4}[AEIW]: /	contained	contains=olInfo,olKey	nextgroup=olTextInfo	skipwhite
syn match olLogLevel	/\vA +[A-Z0-9]{2,5}[0-9]{4}[AEIW]: /	contained	contains=olAudit,olKey	nextgroup=olTextAudit	skipwhite
syn match olLogLevel	/\vW +[A-Z0-9]{2,5}[0-9]{4}[AEIW]: /	contained	contains=olWarn,olKey	nextgroup=olTextWarn	skipwhite
syn match olLogLevel	/\vE +[A-Z0-9]{2,5}[0-9]{4}[AEIW]: /	contained	contains=olError,olKey	nextgroup=olTextError	skipwhite
syn match olInfo	/I/					contained
syn match olAudit	/A/					contained
syn match olWarn	/W/					contained
syn match olError	/E/					contained
syn match olKey		/\v +\w+:/				contained
syn match olText	/\v.*$/					contained	contains=olHexData,olStack			skipWhite
syn match olTextInfo	/\v.*$/					contained	contains=olHexData,olStack
syn match olTextAudit	/\v.*$/					contained	contains=olHexData,olStack
syn match olTextWarn	/\v.*$/					contained	contains=olHexData,olStack
syn match olTextError	/\v.*$/					contained	contains=olHexData,olStack

" and try to capture any additional traced items
syn match olTextCont	/\v^(\[[^\]]*\])@!.*/						contains=olMsgDir,olMsgType,olMsgAttr,olHexIndex,olHexData,olStack
" match indented continuation lines as Liberty trace text
syn match olIndented	/\v^ {100}.*$/							contains=olText
" match the pre-amble (note: this must come AFTER olTextCont to supersede it)
syn region olPrologue	start=/\v^\*{80}/ end=/\v^\*{80}/ 				contains=olProperty
syn match olProperty	/\v^[^ ]+ = .*$/				contained


" define parts of ORB communications trace
syn match olMsgDir	/\v(IN COMING|OUT GOING):/			contained
syn match olMsgType	/\v^(\w+ ){1,2}Message$/			contained
syn match olMsgAttr	/\v(Date|Thread Info|GIOP Version|Byte order):/	contained
syn match olMsgAttr	/\v(Local|Remote) (Port|IP):/			contained
syn match olMsgAttr	/\v(Message size|Request ID|Reply Status):/ 	contained
syn match olMsgAttr	/\v(Data Offset|Object Key|Operation):/ 	contained
syn match olMsgAttr	/\v(Fragment to follow|Response Flag):/ 	contained
syn match olMsgAttr	/\v(Service Context|Target Address):/ 		contained
syn match olHexIndex	/\v^[0-9A-F]{4}:/				contained
syn match olHexData	/\v[0-9A-F][0-9A-F ]{7} ([0-9A-F ]{8} ){3}/	contained	contains=olValueTag,olPadding
syn match olValueTag	/\v7FFFFF[0-9A-F]{2}/
syn match olPadding	/\v(BD)+ /
syn match olPadding	/\v( ..)@<=BD/

" define the 'incidental' hex data that may appear all over the place
syn match olHexData	/0x[0-9A-F]\+/					contained
syn match olHexData	/\v(IOR:)@<=[0-9A-F]{10,}/			contained
syn match olHexData	/\v(\@)@<=[0-9A-F]{4,}/				contained
syn match olHexData	/\v(\=)@<=[0-9A-F]{10,}([[:alnum:]])@!/		contained

" treat stack trace lines specially
syn match olStack	/\vat [^ \.(]+(\.[^ \.(]+)+\((.*:\d+|Native Method)\)$/
syn match olStack	/\v\.\.\. \d+ more$/

" indicate how to highlight each bit of Liberty trace
hi def link olProperty	Define
hi def link olTimestamp	Label
hi def link olThread	Constant
hi def link olObjectId	Macro
hi def link olComponent	Type
hi def link olLogLevel	Operator
hi def link olIndent	Ignore
hi def link olText	Comment
hi def link olTextCont	Comment
hi def link olKey	Constant
hi def link olMsgDir	Underlined
hi def link olMsgType	Constant
hi def link olMsgAttr	Identifier
hi def link olHexIndex	Label
hi def link olHexData	Number
hi def link olHexAscii	Comment
hi def link olValueTag	Underlined
hi def link olPadding	Ignore
hi def link olInfo	Underlined
hi def link olTextInfo	Underlined
hi def link olAudit	CursorIM
hi def link olTextAudit	CursorIM
hi def link olWarn	Todo
hi def link olTextWarn	Todo
hi def link olError	Error
hi def link olTextError	Error
hi def link olStack	Error



