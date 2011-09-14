package
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import format.swf.Method_body_info;
	import format.swf.OpCodes;
	import format.swf.Script_info;
	import format.swf.Trait_class;
	import format.swf.tag.DoABC;
	import format.swf.utils.SwfFileCode;
	import format.swf.writer.SwfWriter;

	public class AddJumpOperation
	{
		private var data:ByteArray;
		
		public var finalData:ByteArray;
		
		private var addCodeSwf:ByteArray;

		private var methodBody:Method_body_info;
		
		public function AddJumpOperation(data:ByteArray)
		{
			this.data = data;
			doData();
		}
		
		private function doData():void
		{
			var lengthDelta:uint = 0;
			var swfFile:SwfFileCode = new SwfFileCode(data);
			var addCodeSwf:ByteArray = swfFile.bytesUncompressWithOutHeader;
			var doabc:DoABC = swfFile.documentDoabc;
			
//			methodBody = Method_body_info(doabc.abcfile.method_body[swfFile.documentInstance.iinit]);
//			new OpCodes(methodBody.code);//test
			var jumpCode:ByteArray = getJumpCode();
			var methodBody_arr:Array = doabc.abcfile.method_body;
			for(var i:int = methodBody_arr.length -1;i>=0;i--)
			{
				methodBody = methodBody_arr[i] as Method_body_info;
				lengthDelta += SwfWriter.replayAndAddBytes(addCodeSwf,methodBody.code_offset,0,jumpCode);
				addCodeSwf.position = methodBody.code_length_offset;
				lengthDelta += SwfWriter.replayVU32(addCodeSwf,jumpCode.length + methodBody.code.length);
			}
//			lengthDelta += SwfWriter.replayAndAddBytes(addCodeSwf,methodBody.code_offset,0,jumpCode);
//			
//			addCodeSwf.position = methodBody.code_length_offset;
//			lengthDelta += SwfWriter.replayVU32(addCodeSwf,jumpCode.length + methodBody.code.length);
			
			var addTagLengthByte:ByteArray = new ByteArray;
			var oldTagHeaderLength:int = (doabc.tag.length >= 0x3f)?6:2;
			SwfWriter.writeSwfTagCodeAndLength(addTagLengthByte,swfFile.documentDoabcTag,doabc.tag.length + lengthDelta);
			SwfWriter.replayAndAddBytes(addCodeSwf,doabc.tag.offset,oldTagHeaderLength,addTagLengthByte);//新的DoABC tag Header写进swf;
			
			var header:ByteArray = swfFile.bytesHeaderTag;
			header.position = 4;
			header.writeInt(addCodeSwf.length + 8);
			finalData = SwfWriter.getSwfByteData(header,addCodeSwf);//生成新的swf
		}
		
		private function getJumpCode():ByteArray
		{
			var byte:ByteArray = new ByteArray;
			byte.endian = Endian.LITTLE_ENDIAN;
			
			byte.writeByte(0x10);//jump
			SwfWriter.writeS24(byte,8);
			byte.writeByte(0x1b);
			SwfWriter.writeS24(byte,-1048212);
			SwfWriter.writeVU32(byte,0xfffffff);
			return byte;
//			byte.writeByte(0x10);//jump
//			SwfWriter.writeS24(byte,5);
//			byte.writeByte(0x09);//Label
//			byte.writeByte(0x10);//jump
//			SwfWriter.writeS24(byte,-5);
//			byte.writeByte(0xd0);//getlocal0
//			byte.writeByte(0x11);//iftrue
//			SwfWriter.writeS24(byte,4);
//			byte.writeByte(0x10);//jump
//			SwfWriter.writeS24(byte,-14);
		}
		
	}
}