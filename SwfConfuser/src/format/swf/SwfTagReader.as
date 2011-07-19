package format.swf
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import format.swf.tag.TagOfSwf;
	
	import yzhkof.util.BitReader;
	
	public class SwfTagReader
	{
		public var tagMap:Dictionary=new Dictionary();//<tag.type,SWFTAG>
		public var tagArray:Array=new Array();//<SwfTag>	
		public var tagTypeArray:Array=new Array;//<int>
		private var _hasNext:Boolean=true;
		private var byte:ByteArray;
		private var bitReader:BitReader;
		public function SwfTagReader(byte:ByteArray)
		{
			this.byte=byte;
			if(byte.length>2)
				_hasNext=true;
			read();
		}
		public function hasTagType(type:int):Boolean
		{
			return 	tagMap[type];
		}
		public function getTagByType(type:int):Array
		{
			return tagMap[type];
		}
		public function getTagReaderByType(type:int):Array
		{
			var re_arr:Array=new Array;
			var tag_arr:Array=getTagByType(type);
			for each(var i:SwfTag in tag_arr)
			{
				re_arr.push(getTagReader(i));
			}
			
			return re_arr;
		}
		public function isDebug():Boolean
		{
			return hasTagType(58)||hasTagType(64);
		}
		private function read():void
		{
			bitReader=new BitReader(byte);
			while(hasNext)
			{
				var t:SwfTag=readNextTag();
				if(tagMap[t.type])
				{
					tagMap[t.type].push(t);
				}else
				{
					tagMap[t.type]=[t];
				}
				tagArray.push(t);
				if(tagTypeArray.indexOf(t.type)==-1)
					tagTypeArray.push(t.type);
			}
		}
		private function readNextTag():SwfTag
		{
			var tag:SwfTag=new SwfTag(byte);
			var shortTagLength:int;
			var longTagLength:int;
			
			var t:uint=byte.readUnsignedShort();
			
//			tag.data=new ByteArray();
//			tag.data.endian=Endian.LITTLE_ENDIAN;
			
			tag.type=BitReader.getBytesBits(t,16,0,10);
			shortTagLength=BitReader.getBytesBits(t,16,10,16);
			if(shortTagLength>=0x3f)
			{
				longTagLength=byte.readInt();	
			}
			var l:uint=longTagLength||shortTagLength;
			//byte.position+=l;
			tag.offset=byte.position;
//			if(l>0)
//				byte.readBytes(tag.data,0,l);
			byte.position+=l;
			
			tag.length=l;
			
			if(tag.type==0)
				_hasNext=false;
			return tag;
		}
		private function get hasNext():Boolean
		{
			return _hasNext;
		}
		private function getTagReader(tag:SwfTag):TagReader
		{
			switch(tag.type)
			{
				case TagOfSwf.DOABC:
					return new DoABC(tag.data);
				case TagOfSwf.SymbolClass:
					return new SymbolClass(tag.data);
			}
			return null;
		}

	}
}