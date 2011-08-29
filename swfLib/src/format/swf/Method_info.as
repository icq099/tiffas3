package format.swf
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	public class Method_info extends ABCFileStructs
	{
		/*
		method_info
		{
			u30 param_count
			u30 return_type
			u30 param_type[param_count]
			u30 name
			u8 flags
			option_info options
			param_info param_names
		}
		
		  */
		public var param_count:uint;
		public var return_type:uint;
		public var param_type:Array;
		public var name:uint;
		public var flags:uint;
		public var options:Option_info;
		public var param_names:Param_info;
		public function Method_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			param_count=readUnsigned30();
			return_type=readUnsigned30();
			param_type=new Array;
			var i:int;
			for(i=0;i<param_count;i++)
			{
				param_type.push(readUnsigned30());
			}
			name=readUnsigned30();
			flags=byte.readUnsignedByte();
			//debug;
//			  try{
//				var mname_i:uint=return_type?cpool_info.multiname[return_type].name:0;			
//				trace("方法名 : "+cpool_info.string[name].utf8str+" 返回类型 : "+((mname_i!=0)?cpool_info.string[mname_i].utf8str:"*"));
//				trace("参数个数 : "+param_count);
//				for(i=0;i<param_count;i++)
//				{
//					mname_i=param_type[i]?cpool_info.multiname[param_type[i]].name:0;
//					trace("参数类型 : "+((mname_i!=0)?cpool_info.string[mname_i].utf8str:"*"));
//				}
//			}catch(e:Error)
//			{
//				
//			}
			if((flags&0x08)!=0)
			{
				options=new Option_info(byte);
			}
			if((flags&0x80)!=0)
			{
				param_names=new Param_info(byte,param_count);
			}
		}
		
	}
}