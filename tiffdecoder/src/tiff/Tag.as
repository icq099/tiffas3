package tiff
{
	import flash.utils.ByteArray;
	
	public class Tag
	{
		public var id:int;
		
		public static const COMPRESSION:int			=259;
		public static const	STRIPOFFSETS:int		=273;	/* offsets to data strips */
		public static const	STRIPBYTECOUNTS:int  	=279;	/* bytes counts for strips */
		
		public static const	UNISYS_ISIS_IFD:int		=33881;	/* offset to ISIS IFD */
		public static const	UNISYS_IXPS_IFD:int		=33884;	/* offset to IXPS IFD */
		
		public static const	WEIRD:int				=34975;
		
		
		public function Tag()
		{
		}
		public function read(inb:ByteArray):void{
			
			id=inb.readUnsignedShort();
		
		}
		public function equals(n:int):Boolean{
			
			return id==n;
		
		}

	}
}