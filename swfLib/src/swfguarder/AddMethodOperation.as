package swfguarder
{
	import avmplus.INCLUDE_ACCESSORS;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import format.swf.ABCFile;
	import format.swf.Instance_info;
	import format.swf.Method_body_info;
	import format.swf.Method_info;
	import format.swf.Multiname_info;
	import format.swf.Namespace_info;
	import format.swf.Script_info;
	import format.swf.String_info;
	import format.swf.SwfFile;
	import format.swf.Trait_class;
	import format.swf.Traits_info;
	import format.swf.tag.DoABC;
	import format.swf.tag.SymbolClass;
	import format.swf.tag.TagOfSwf;
	import format.swf.utils.SwfFileCode;
	import format.swf.writer.SwfWriter;

	public class AddMethodOperation extends SwfGuarderOperation
	{
		private var data:ByteArray;
		
		public var finalData:ByteArray;
		
		private var doabc:DoABC;
		
		private var addCodeSwf:ByteArray;
		
		private var lengthDelta:int;
		
		private var ADD_METHOD_COUNT:uint = 1000;

		private var documentInstance:Instance_info;
		
		public function AddMethodOperation(data:ByteArray)
		{
			this.data = data;
			finalData = data;
		}
		public function doData():void
		{
			lengthDelta = 0;
			var swfFile:SwfFileCode = new SwfFileCode(data);
			addCodeSwf = swfFile.bytesUncompressWithOutHeader;
			var symbolClass_arr:Array = swfFile.tagReader.getTagReaderByType(TagOfSwf.SymbolClass);
			if((symbolClass_arr == null)||(symbolClass_arr.length <= 0))
			{
				onComplete.dispatch(finalData);
				return;
			}
			
			doabc = swfFile.documentDoabc;
			
//			doabc = swfFile.tagReader.getTagReaderByType(TagOfSwf.DOABC)[2] as DoABC;
			
			var i:int = 0;
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var stringCountOff:int = doabc.abcfile.constant_pool.string_offset;
			addCodeSwf.position = stringCountOff;
			var stringCount:int = doabc.abcfile.constant_pool.string_count + ADD_METHOD_COUNT;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,stringCount);//改变cpool里StringCount的值;
			
			var stringsArr:Array = doabc.abcfile.constant_pool.string;
			for (i; i < ADD_METHOD_COUNT; i++) 
			{
				addStringInfo(String(i));
			}
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var namespaceCountOff:int = doabc.abcfile.constant_pool.namespace_offset + lengthDelta;
			addCodeSwf.position = namespaceCountOff;
			var namespaceCount:int = doabc.abcfile.constant_pool.namespace_count  + ADD_METHOD_COUNT ;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,namespaceCount);//改变cpool里NameSpaceCount的值;
			
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var namespaceArr:Array = doabc.abcfile.constant_pool.namespace_abc;
			for (i = 0; i < ADD_METHOD_COUNT; i++) 
			{
				addNameSpace(0x16,stringsArr.length + i);
			}
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var multiNameCountOff:int = doabc.abcfile.constant_pool.multiname_offset + lengthDelta;
			addCodeSwf.position = multiNameCountOff;
			var multiNameCount:int = doabc.abcfile.constant_pool.multiname_count + ADD_METHOD_COUNT;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,multiNameCount);//改变cpool里MultiNameCount的值;
			
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var multiNameArr:Array = doabc.abcfile.constant_pool.multiname;
			for (i = 0; i < ADD_METHOD_COUNT; i++) 
			{
				addMultiName(0x07,namespaceArr.length,stringsArr.length + i);
			}
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var methodCountOff:int = doabc.abcfile.method_offset + lengthDelta;
			addCodeSwf.position = methodCountOff;
			var methodCount:int = doabc.abcfile.method_count  + ADD_METHOD_COUNT ;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,methodCount);//改变doabc里methodCount的值;
			
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var methodArr:Array = doabc.abcfile.method;
			for (i = 0; i < ADD_METHOD_COUNT; i++) 
			{
				addMethod(0,0,[],stringsArr.length + i,0);
			}
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			documentInstance = swfFile.documentInstance;
			var final_traitCount_offset:int = documentInstance.trait_offset + lengthDelta;
			var taintsCount:uint = documentInstance.trait_count  + ADD_METHOD_COUNT;
			addCodeSwf.position = final_traitCount_offset;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,taintsCount);//Instance的traitCount;
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			for (i = 0; i < ADD_METHOD_COUNT; i++) 
			{
				addDocumentTraits(multiNameArr.length + i,0x12,0,methodArr.length + i);
			}
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var methodBodyCountOff:int = doabc.abcfile.method_body_offset + lengthDelta;
			addCodeSwf.position = methodBodyCountOff;
			var methodBodyCount:int = doabc.abcfile.method_body_count + ADD_METHOD_COUNT;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,methodBodyCount);//改变doabc里methodBodyCount的值;
			
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var methodBodyArr:Array = doabc.abcfile.method_body;
			var code:ByteArray = new ByteArray;
			code.writeByte(0x1b);
			SwfWriter.writeS24(code,-1);
			SwfWriter.writeVU32(code,0x10000000);
			
			for (i = 0; i < ADD_METHOD_COUNT; i++) 
			{
				addMethodBody(methodArr.length + i,2,2,9,10,code.length,code);
			}
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var addTagLengthByte:ByteArray = new ByteArray;
			var oldTagHeaderLength:int = (doabc.tag.length >= 0x3f)?6:2;
			SwfWriter.writeSwfTagCodeAndLength(addTagLengthByte,swfFile.documentDoabcTag,doabc.tag.length + lengthDelta);
			SwfWriter.replayAndAddBytes(addCodeSwf,doabc.tag.offset,oldTagHeaderLength,addTagLengthByte);//新的DoABC tag Header写进swf;
			
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var header:ByteArray = swfFile.bytesHeaderTag;
			header.position = 4;
			header.writeInt(addCodeSwf.length + 8);
			finalData = SwfWriter.getSwfByteData(header,addCodeSwf);//生成新的swf
			onComplete.dispatch(finalData);
			
		}
		
		private function addStringInfo(string:String):void
		{
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var stringsArr:Array = doabc.abcfile.constant_pool.string;
			var final_string_offset:int = String_info(stringsArr[stringsArr.length-1]).offset + String_info(stringsArr[stringsArr.length-1]).length + lengthDelta;
			var addStringByte:ByteArray = new ByteArray;
			addStringByte.endian = Endian.LITTLE_ENDIAN;
			SwfWriter.writeStringInfo(addStringByte,string);
			SwfWriter.replayAndAddBytes(addCodeSwf,final_string_offset,0,addStringByte);//StringInfo写进cpool;
			lengthDelta += addStringByte.length;
		}
		
		private function addMultiName(kind:uint,ns:uint = 0 ,name:uint = 0):void
		{
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var multiNameArr:Array = doabc.abcfile.constant_pool.multiname;
			var final_multiname_offset:int = Multiname_info(multiNameArr[multiNameArr.length-1]).offset + Multiname_info(multiNameArr[multiNameArr.length-1]).length + lengthDelta;
			var addMultiNameByte:ByteArray = new ByteArray;
			addMultiNameByte.endian = Endian.LITTLE_ENDIAN;
			SwfWriter.writeMultiName(addMultiNameByte,kind,ns,name);
			SwfWriter.replayAndAddBytes(addCodeSwf,final_multiname_offset,0,addMultiNameByte);//MultiNameInfo写进cpool;
			lengthDelta += addMultiNameByte.length;
		}
		
		private function addNameSpace(kind:uint,name:uint = 0):void
		{
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var namespaceArr:Array = doabc.abcfile.constant_pool.namespace_abc;
			var final_namespce_offset:int = Namespace_info(namespaceArr[namespaceArr.length-1]).offset + Namespace_info(namespaceArr[namespaceArr.length-1]).length + lengthDelta;
			var addNamespaceByte:ByteArray = new ByteArray;
			addNamespaceByte.endian = Endian.LITTLE_ENDIAN;
			SwfWriter.writeNameSpaceInfo(addNamespaceByte,kind,name);
			SwfWriter.replayAndAddBytes(addCodeSwf,final_namespce_offset,0,addNamespaceByte);//NameSpaceInfo写进cpool;
			lengthDelta += addNamespaceByte.length;
		}
		
		private function addMethod(param_count:uint,return_type:uint,param_type:Array,name:uint,
								   flags:int):void
		{
			var methodArr:Array = doabc.abcfile.method;
			var final_method_offset:int = Method_info(methodArr[methodArr.length-1]).offset +Method_info(methodArr[methodArr.length-1]).length + lengthDelta;
			var addMethodByte:ByteArray = new ByteArray
			addMethodByte.endian = Endian.LITTLE_ENDIAN;
			SwfWriter.writeMethod(addMethodByte,param_count,return_type,param_type,name,flags);
			SwfWriter.replayAndAddBytes(addCodeSwf,final_method_offset,0,addMethodByte);//MethodInfo写进cpool;
			lengthDelta += addMethodByte.length;
		}
		
		private function addMethodBody(method:uint,max_stack:uint,local_count:uint,
									   init_scope_depth:uint,max_scope_depth:uint,code_length:uint,
									   opcodeBytes:ByteArray):void
		{
			var methodBodyArr:Array = doabc.abcfile.method_body;
			var final_methodBody_offset:int = Method_body_info(methodBodyArr[methodBodyArr.length-1]).offset + Method_body_info(methodBodyArr[methodBodyArr.length-1]).length + lengthDelta;
			var addMethodBodyByte:ByteArray = new ByteArray
			addMethodBodyByte.endian = Endian.LITTLE_ENDIAN;
			SwfWriter.writeMethodBody(addMethodBodyByte,method,max_stack,local_count,init_scope_depth,max_scope_depth,code_length,opcodeBytes);
			SwfWriter.replayAndAddBytes(addCodeSwf,final_methodBody_offset,0,addMethodBodyByte);//MethodBodyInfo写进cpool;
			lengthDelta += addMethodBodyByte.length;
		}
		
		private function addDocumentTraits(name:uint,kind:uint,disp_id:uint,method:uint):void
		{
			var final_traitadd_offset:int;
			final_traitadd_offset = documentInstance.offset + documentInstance.length + lengthDelta;
			addCodeSwf.position = final_traitadd_offset;
			var traitBytes:ByteArray = new ByteArray;//trait的bytesArray
			traitBytes.endian = Endian.LITTLE_ENDIAN;
			SwfWriter.writeVU32(traitBytes,name);//trait的名字(方法的名字);
			traitBytes.writeByte(kind);//getter override;
			SwfWriter.writeVU32(traitBytes,disp_id);
			SwfWriter.writeVU32(traitBytes,method);//method的索引;
			SwfWriter.replayAndAddBytes(addCodeSwf,final_traitadd_offset,0,traitBytes);//trait写进instance;
			lengthDelta += traitBytes.length;
		}
		
	}
}