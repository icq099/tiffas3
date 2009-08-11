package tiff
{
	import flash.utils.ByteArray;
	
	import tiff.util.ByteUtil;
	
	public class IFDEntry
	{
		public static const SIZE:int = 12;
		
		public var tag:Tag;
		public var type:DataType;
		public var count:int;
		public var value:int;
		
		public var dataArray:ByteArray;
		
		public function IFDEntry()
		{
			init();
		}
		private function init():void{
			
			tag=new Tag();
			type = new DataType();
			count = 0;
			value = 0;
			dataArray = null;
					
		}
		public function read(inb:ByteArray,ifdOffset:int=0):void{
			
//			tag.read(inb);//这个暂时没写好
			type.read(inb);
			count=inb.readInt();
			value=inb.readInt();
			
			if (isOffset()) {
				var len:int = sizeOfData(); 
				var currentOffset:int = inb.position;
				dataArray = new ByteArray();
				inb.position=value+ifdOffset;
				if (type.isAscii())  ByteUtil.readFully(inb,dataArray,len);
				else if(type.isRational()){
					var t:DataType=new DataType(DataType.LONG);
					var b:ByteArray=new ByteArray;
					if(ByteUtil.isInter(inb)){
						ByteUtil.readProperly(inb,dataArray,t.size(),4);
						ByteUtil.readProperly(inb,b,t.size(),4);
						dataArray.position=4;
						dataArray.writeBytes(b,0,4);
					}else{
						ByteUtil.readFully(inb,dataArray,len);
					}
				}
				else{
					ByteUtil.readProperly(inb,dataArray,type.size(),len);				
				}
				inb.position=currentOffset; 
			}
			if (type.isShort() && !ByteUtil.isInter(inb))
				value = int(value>>16)&0xffff;
		
		}
		public function isOffset():Boolean{
			
			return (sizeOfData()>4);
		
		}
		public function sizeOfData():int{
			
			return int(count)*type.size();
		
		}
		public function setOffset(n:int):void{
			value=n;
		}

	}
}