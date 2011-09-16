package
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import format.swf.Method_body_info;
	import format.swf.OpCodes;
	import format.swf.Script_info;
	import format.swf.Trait_class;
	import format.swf.tag.DoABC;
	import format.swf.tag.TagOfSwf;
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
			finalData = data;
			doData();
		}
		
		private function doData():void
		{
			var totalLengthDelta:uint = 0;
			var swfFile:SwfFileCode = new SwfFileCode(data);
			var addCodeSwf:ByteArray = swfFile.bytesUncompressWithOutHeader;
			
			var jumpCode:ByteArray = getJumpCode();
			var startCode:ByteArray = getStartCode();
			var methodBody_arr:Array;
			
			if(swfFile.documentDoabc == null) return;
			
			var doabc_arr:Array = swfFile.doabc_array;
//			var doabc:DoABC = doabc_arr[2];
			for each (var doabc:DoABC in doabc_arr) 
			{
				var lengthDelta:uint = 0;
				methodBody_arr = doabc.abcfile.method_body;
//				for(var i:int = methodBody_arr.length -1;i>=0;i--)
				for(var i:int = 0;i < methodBody_arr.length;i++)
				{
					methodBody = methodBody_arr[i] as Method_body_info;
					
					addCodeSwf.position = methodBody.code_length_offset + lengthDelta +totalLengthDelta;
					lengthDelta += SwfWriter.replayVU32(addCodeSwf,jumpCode.length + methodBody.code.length + startCode.length);
					lengthDelta += SwfWriter.replayAndAddBytes(addCodeSwf,methodBody.code_offset + lengthDelta + totalLengthDelta + 2 ,0,startCode);
					lengthDelta += SwfWriter.replayAndAddBytes(addCodeSwf,methodBody.code_offset + lengthDelta + totalLengthDelta + methodBody.code.length,0,jumpCode);
				}
				
				var addTagLengthByte:ByteArray = new ByteArray;
				var oldTagHeaderLength:int = (doabc.tag.length >= 0x3f)?6:2;
				SwfWriter.writeSwfTagCodeAndLength(addTagLengthByte,swfFile.documentDoabcTag,doabc.tag.length + lengthDelta);
				totalLengthDelta += SwfWriter.replayAndAddBytes(addCodeSwf,doabc.tag.offset + totalLengthDelta,oldTagHeaderLength,addTagLengthByte);//新的DoABC tag Header写进swf;
				totalLengthDelta += lengthDelta;
			}
			
			var header:ByteArray = swfFile.bytesHeaderTag;
			header.position = 4;
			header.writeInt(addCodeSwf.length + 8);
			finalData = SwfWriter.getSwfByteData(header,addCodeSwf);//生成新的swf
		}
		
		private function getStartCode():ByteArray
		{
			var byte:ByteArray = new ByteArray;
			byte.endian = Endian.LITTLE_ENDIAN;
//			byte.writeByte(0x10);//jump
//			SwfWriter.writeS24(byte,5);
//			byte.writeByte(0x56);
//			SwfWriter.writeVU32(byte,0xfffffff);
//			byte.writeByte(0xd0);
//			byte.writeByte(0xd0);
			return byte;
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
			
//			byte.writeByte(0x10);//jump
//			SwfWriter.writeS24(byte,5);
//			byte.writeByte(0x56);
//			SwfWriter.writeVU32(byte,0xfffffff);
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