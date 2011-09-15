package
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

	public class URLCodeAddOperation
	{
		private var data:ByteArray;
		
		
		public var finalData:ByteArray;
		
		private var doabc:DoABC;
		
		private var addCodeSwf:ByteArray;
		
		private var lengthDelta:int;
		
		public function URLCodeAddOperation(data:ByteArray)
		{
			this.data = data;
			finalData = data;
			doData();
		}
		private function doData():void
		{
			lengthDelta = 0;
			var swfFile:SwfFileCode = new SwfFileCode(data);
			addCodeSwf = swfFile.bytesUncompressWithOutHeader;
			var symbolClass_arr:Array = swfFile.tagReader.getTagReaderByType(TagOfSwf.SymbolClass);
			if((symbolClass_arr == null)||(symbolClass_arr.length <= 0)) return;
			
			doabc = swfFile.documentDoabc;
			
			var nag_mn:uint = 0;
			var urlrequest_mn:uint = 0;
			var url_str:uint = 0;
			var blank_str:uint = 0;
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var stringCountOff:int = doabc.abcfile.constant_pool.string_offset;
			addCodeSwf.position = stringCountOff;
			var stringCount:int = doabc.abcfile.constant_pool.string_count + 5;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,stringCount);//改变cpool里StringCount的值;
			
			var stringsArr:Array = doabc.abcfile.constant_pool.string;
			addStringInfo("flash.net");
			addStringInfo("navigateToURL");
			addStringInfo("URLRequest");
			addStringInfo("http://www.baidu.com");
			addStringInfo("_blank");
			url_str = stringsArr.length + 3;
			blank_str = stringsArr.length + 4;
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var namespaceCountOff:int = doabc.abcfile.constant_pool.namespace_offset + lengthDelta;
			addCodeSwf.position = namespaceCountOff;
			var namespaceCount:int = doabc.abcfile.constant_pool.namespace_count  + 1 ;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,namespaceCount);//改变cpool里NameSpaceCount的值;
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var namespaceArr:Array = doabc.abcfile.constant_pool.namespace_abc;
			addNameSpace(0x16,stringsArr.length);
			
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var multiNameCountOff:int = doabc.abcfile.constant_pool.multiname_offset + lengthDelta;
			addCodeSwf.position = multiNameCountOff;
			var multiNameCount:int = doabc.abcfile.constant_pool.multiname_count + 2;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,multiNameCount);//改变cpool里MultiNameCount的值;
			
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var multiNameArr:Array = doabc.abcfile.constant_pool.multiname;
			addMultiName(0x07,namespaceArr.length ,stringsArr.length + 1);//flash.net.navigateToURL
			nag_mn = multiNameArr.length;
			addMultiName(0x07,namespaceArr.length ,stringsArr.length + 2);//flash.net.URLRequest;
			urlrequest_mn = multiNameArr.length + 1;
			
//			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var documentInstance:Instance_info = swfFile.documentInstance;
			var methodBody:Method_body_info = Method_body_info(doabc.abcfile.method_body[swfFile.documentInstance.iinit]);
			if(methodBody.max_stack <3)
			{
				addCodeSwf.position = methodBody.max_stack_offset + lengthDelta;
				lengthDelta += SwfWriter.replayVU32(addCodeSwf,3);
			}
			
			var urlCode:ByteArray = getOpcode(nag_mn,urlrequest_mn,url_str,blank_str);
			
			addCodeSwf.position = methodBody.code_length_offset + lengthDelta;
			lengthDelta += SwfWriter.replayVU32(addCodeSwf,urlCode.length + methodBody.code.length);
			lengthDelta += SwfWriter.replayAndAddBytes(addCodeSwf,methodBody.code_offset + methodBody.code_length - 1 + lengthDelta,0,urlCode);
			
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
		
		
		private function getOpcode(nag_mn:uint,urlrequest_mn:uint,url_str:uint,blank_str:uint):ByteArray
		{
			var byte:ByteArray = new ByteArray;
			byte.endian = Endian.LITTLE_ENDIAN;
			byte.writeByte(0x5d);//findpropstrict navigateToURL
			SwfWriter.writeVU32(byte,nag_mn);
			byte.writeByte(0x5d);//findpropstrict URLRequest
			SwfWriter.writeVU32(byte,urlrequest_mn);
			byte.writeByte(0x2c);//pushstring "http://www.baidu.com"
			SwfWriter.writeVU32(byte,url_str);
			byte.writeByte(0x4a);//constructprop URLRequest, 1 args
			SwfWriter.writeVU32(byte,urlrequest_mn);
			SwfWriter.writeVU32(byte,1);
			byte.writeByte(0x2c);//pushstring "_blank"
			SwfWriter.writeVU32(byte,blank_str);
			byte.writeByte(0x4f);//callpropvoid navigateToURL, 2 args
			SwfWriter.writeVU32(byte,nag_mn);
			SwfWriter.writeVU32(byte,2);
			return byte;
			
//			findpropstrict navigateToURL
//			@6      findpropstrict URLRequest
//			@7      pushstring "http://www.baidu.com"
//			@8      constructprop URLRequest, 1 args
//			@9      pushstring "_blank"
//			@10     callpropvoid navigateToURL, 2 args
		}
	}
}