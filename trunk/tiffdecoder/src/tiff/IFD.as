package tiff
{
	import flash.utils.ByteArray;
	
	public class IFD
	{
		public var count:int;
		public var entries:Array;//type IFDEntry;
		public var offset:int;
		
		private var cImg:CodedImage;
		private var unisys:IFD;
		
		public function IFD()
		{
			init();
		}
		private function init():void{
			
			count = 0;
			entries = null;
			offset = 0;
			cImg = null;
			unisys = null;
		
		}
		private function GetEntry(id:int):IFDEntry{
			
			for (var i:int=0; i<count; i++) {
				
				if (IFDEntry(entries[i]).tag.equals(id)) return entries[i];
				
			}
			return null;
		
		}
		private function GetFieldValue(id:int):int{
			
			for (var i:int=0; i<count; i++) {
				if (IFDEntry(entries[i]).tag.equals(id)) return int(IFDEntry(entries[i]).value);
			}
			return 0;
			
		}
		private function GetCompressionType():int {
			
			return GetFieldValue(Tag.COMPRESSION);
			
		}
		private function size():int {
			
			return (2 + IFDEntry.SIZE * count + 4); //count + tags + offset
			
		}
		
		public function read(inb:ByteArray):void{
			
			var i:int, nStripOffsets:int=0, nStripByteCounts:int=0;
			var s:String;
			var compType:int=0;
			
			count=inb.readUnsignedShort();
			entries=new Array();
			
			for(i=0;i<count;i++){
				entries.push(new IFDEntry());
				IFDEntry(entries[i]).read(inb);
				
				if (entries[i].tag.equals(Tag.COMPRESSION))
					compType = int(IFDEntry(entries[i]).value);

				if (entries[i].tag.equals(Tag.STRIPBYTECOUNTS))
					nStripByteCounts = i;
	
				if (entries[i].tag.equals(Tag.STRIPOFFSETS))
					nStripOffsets = i;
	
				if (entries[i].tag.equals(Tag.UNISYS_ISIS_IFD)) {
					unisys = new UnisysISIS_IFD();
					unisys.offset = IFDEntry(entries[i]).value;
				}
	
				if (entries[i].tag.equals(Tag.WEIRD)) {
					unisys = new Weird_IFD();
					unisys.offset = entries[i].value;
				}
	
				if (entries[i].tag.equals(Tag.UNISYS_IXPS_IFD)) {
					unisys = new UnisysIXPS_IFD();
					unisys.offset = entries[i].value;
				}
			}
			offset = inb.readInt();
			
			switch (compType) {
				case CompressionType.NONE:			cImg = new RawImage(this); break;
				//case CompressionType.CCITTRLE:		cImg = new CCITTRLEImage(this); break;
				case CompressionType.CCITTFAX3:		cImg = new CCITTG3Image(this); break;
				//case CompressionType.CCITTFAX4:		cImg = new CCITTG4Image(this); break;
				case CompressionType.OJPEG:
				//case CompressionType.JPEG:				cImg = new JPEGImage(this); break;
				//case CompressionType.PACKBITS:		cImg = new PackbitsImage(this); break;
	
				/*don't do these types yet*
				case CompressionType.CCITTRLEW:		cImg = new CCITTImage(this); break;
				case CompressionType.LZW:	 				cImg = new LZWImage(this); break;
				case CompressionType.NEXT:				cImg = new NeXTImage(this); break;
				case CompressionType.THUNDERSCAN:	cImg = new ThunderScanImage(this); break;
	 			*don't do these types yet*/
	
		  		default:				cImg = new CodedImage(this); break;
			}
			readImageBytes(inb, nStripOffsets, nStripByteCounts );
			if (unisys != null) {
				inb.position=int(unisys.offset);
				unisys.read( inb );
			}	
		}
		private function readImageBytes(inb:ByteArray,nOffsets:int,nCounts:int):void{
			var i:int,len:int=0;
			
			if(nCounts!=0 && entries[nCounts].isOffset()){
				
				var count:int=entries[nCounts].count;
				var countArray:Array=new Array();
				
				cImg.imageStrips=new Array;
				
				inb.position=entries[nCounts].value;
				for(i=0,len=0;i<count;i++){
					countArray[i]=inb.readInt();
					len+=countArray[i];				
				}
				
				var offsetArray:Array = new Array;
				inb.position=entries[nOffsets].value;
				for (i=0; i<count; i++) {
					offsetArray[i] = inb.readInt();
				}
				
				var n:int=0;

				for (i=0; i<count; i++) {
					cImg.imageStrips.push(new ByteArray);
					inb.position=offsetArray[i];
					inb.readBytes(cImg.imageStrips[i],inb.position,uint(countArray[i]));
					n += countArray[i];
				}
			
			}
			else{
				
				var offset:int = entries[nOffsets].value;
				len = (nCounts>0 ? entries[nCounts].value : inb.length-offset );
				cImg.imageBytes = new ByteArray;
				inb.position=offset;
				inb.readBytes(cImg.imageBytes,inb.position,len);
				
			}
		
		}

	}
}