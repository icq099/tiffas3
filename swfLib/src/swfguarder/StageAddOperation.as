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

	public class StageAddOperation extends SwfGuarderOperation
	{
		private var data:ByteArray;
		
		[Embed(source="./asset/opcode",mimeType="application/octet-stream")]
		private var opcodeClass:Class;
		
		public var finalData:ByteArray;
		
		private var doabc:DoABC;
		
		private var addCodeSwf:ByteArray;
		
		private var lengthDelta:int;
		
		public function StageAddOperation(data:ByteArray)
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
			
			var object_mn:uint = 0;
			var prototype_mn:uint = 0;
			var stage_mn:uint = 0;
			var Stage_mn:uint = 0;
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var stringCountOff:int = doabc.abcfile.constant_pool.string_offset;
			addCodeSwf.position = stringCountOff;
			var stringCount:int = doabc.abcfile.constant_pool.string_count + 7;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,stringCount);//改变cpool里StringCount的值;
			
			var stringsArr:Array = doabc.abcfile.constant_pool.string;
			addStringInfo("stage");
			addStringInfo("Stage");
			addStringInfo("SuperShopLoader/stage/get");
			addStringInfo("prototype");
			addStringInfo("Object");
			addStringInfo("flash.display");
			addStringInfo("");
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var namespaceCountOff:int = doabc.abcfile.constant_pool.namespace_offset + lengthDelta;
			addCodeSwf.position = namespaceCountOff;
			var namespaceCount:int = doabc.abcfile.constant_pool.namespace_count  + 2 ;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,namespaceCount);//改变cpool里NameSpaceCount的值;
			
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var namespaceArr:Array = doabc.abcfile.constant_pool.namespace_abc;
			addNameSpace(0x16,stringsArr.length + 5);
			addNameSpace(0x16,stringsArr.length + 6);
			
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var multiNameCountOff:int = doabc.abcfile.constant_pool.multiname_offset + lengthDelta;
			addCodeSwf.position = multiNameCountOff;
			var multiNameCount:int = doabc.abcfile.constant_pool.multiname_count + 4;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,multiNameCount);//改变cpool里MultiNameCount的值;
			
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var multiNameArr:Array = doabc.abcfile.constant_pool.multiname;
			addMultiName(0x07,namespaceArr.length + 1,stringsArr.length);//文档类.stage(文档类)
			stage_mn = multiNameArr.length;
			addMultiName(0x07,namespaceArr.length,stringsArr.length + 1);//flash.display.Stage;
			Stage_mn = multiNameArr.length + 1;
			addMultiName(0x07,namespaceArr.length + 1,stringsArr.length + 3);//prototype;
			prototype_mn = multiNameArr.length + 2;
			addMultiName(0x07,namespaceArr.length + 1,stringsArr.length + 4);//Object;
			object_mn = multiNameArr.length + 3;
			
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var methodCountOff:int = doabc.abcfile.method_offset + lengthDelta;
			addCodeSwf.position = methodCountOff;
			var methodCount:int = doabc.abcfile.method_count  + 1 ;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,methodCount);//改变doabc里methodCount的值;
			
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var methodArr:Array = doabc.abcfile.method;
			var final_method_offset:int = Method_info(methodArr[methodArr.length-1]).offset +Method_info(methodArr[methodArr.length-1]).length + lengthDelta;
			var addMethodByte:ByteArray = new ByteArray
			addMethodByte.endian = Endian.LITTLE_ENDIAN;
			SwfWriter.writeMethod(addMethodByte,0,Stage_mn,[],stringsArr.length + 2,0);
			SwfWriter.replayAndAddBytes(addCodeSwf,final_method_offset,0,addMethodByte);//MethodInfo写进cpool;
			lengthDelta += addMethodByte.length;
			
			
//			var scriptInfo:Script_info = doabc.abcfile.script[doabc.abcfile.script_count - 1];
//			documentIIIndex = Trait_class(Traits_info(scriptInfo.trait[0]).data).classi;//找到文档类的instanceInfo
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var documentInstance:Instance_info = swfFile.documentInstance;
			var final_traitCount_offset:int = documentInstance.trait_offset + lengthDelta;
			var taintsCount:uint = documentInstance.trait_count  + 1   ;
			addCodeSwf.position = final_traitCount_offset;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,taintsCount);//Instance的traitCount;
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var traitInfo:Traits_info = Traits_info(documentInstance.trait[documentInstance.trait_count - 1]);
			var final_traitadd_offset:int;
			if(traitInfo)
			{
				final_traitadd_offset = traitInfo.offset + traitInfo.length + lengthDelta;
			}
			else
			{
				final_traitadd_offset = addCodeSwf.position;
			}
			addCodeSwf.position = final_traitadd_offset;
			var traitBytes:ByteArray = new ByteArray;//trait的bytesArray
			traitBytes.endian = Endian.LITTLE_ENDIAN;
			SwfWriter.writeVU32(traitBytes,stage_mn);//trait的名字(方法的名字);
			traitBytes.writeByte(0x22);//getter override;
			SwfWriter.writeVU32(traitBytes,0);
			SwfWriter.writeVU32(traitBytes,methodArr.length);//method的索引;
			SwfWriter.replayAndAddBytes(addCodeSwf,final_traitadd_offset,0,traitBytes);//trait写进instance;
			lengthDelta += traitBytes.length;
			
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var methodBodyCountOff:int = doabc.abcfile.method_body_offset + lengthDelta;
			addCodeSwf.position = methodBodyCountOff;
			var methodBodyCount:int = doabc.abcfile.method_body_count + 1;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,methodBodyCount);//改变doabc里methodBodyCount的值;
			
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var methodBodyArr:Array = doabc.abcfile.method_body;
			var final_methodBody_offset:int = Method_body_info(methodBodyArr[methodBodyArr.length-1]).offset + Method_body_info(methodBodyArr[methodBodyArr.length-1]).length + lengthDelta;
			var addMethodBodyByte:ByteArray = new ByteArray
			addMethodBodyByte.endian = Endian.LITTLE_ENDIAN;
			var code:ByteArray = ByteArray(new opcodeClass);
			doOpcode(code,object_mn,prototype_mn,stage_mn,Stage_mn);
			SwfWriter.writeMethodBody(addMethodBodyByte,methodArr.length,2,1,9,10,code.length,code);
			SwfWriter.replayAndAddBytes(addCodeSwf,final_methodBody_offset,0,addMethodBodyByte);//MethodBodyInfo写进cpool;
			lengthDelta += addMethodBodyByte.length;
			
			
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
		
		
		private function doOpcode(code:ByteArray,object_mn:uint,prototype_mn:uint,stage_mn:uint,Stage_mn:uint):void
		{
			code.endian = Endian.LITTLE_ENDIAN;
			code.readUnsignedByte();//getlocal 0;
			code.readUnsignedByte();//pushscope;
			code.readUnsignedByte();//getlex Object;
			SwfWriter.replayVU32(code,object_mn);
			code.readUnsignedByte();//getproperty prototype;
			SwfWriter.replayVU32(code,prototype_mn);
			code.readUnsignedByte();//getproperty stage;
			SwfWriter.replayVU32(code,stage_mn);
			code.readUnsignedByte();//coerce Stage;
			SwfWriter.replayVU32(code,Stage_mn);
			code.readUnsignedByte();//dup;
			code.readUnsignedByte();//iftrue;
			SwfWriter.readS24(code);
			code.readUnsignedByte();//pop;
			code.readUnsignedByte();//getlocal 0;
			code.readUnsignedByte();//getsuper stage;
			SwfWriter.replayVU32(code,stage_mn);
			code.readUnsignedByte();//getlex Stage;
			SwfWriter.replayVU32(code,Stage_mn);
			code.readUnsignedByte();//astypelate;
			code.readUnsignedByte();//coerce Stage;
			SwfWriter.replayVU32(code,Stage_mn);
			code.readUnsignedByte();//returnvalue;
			
//			@1      getlocal 0
//			@2      pushscope 
//			@3      getlex Object
//			@4      getproperty prototype
//			@5      getproperty stage
//			@6      coerce Stage
//			@7      dup 
//			@8      iftrue @15
//				@9      pop 
//			@10     getlocal 0
//			@11     getsuper stage
//			@12     getlex Stage
//			@13     astypelate 
//			@14     coerce Stage
//			@15     returnvalue 
			
		}
	}
}