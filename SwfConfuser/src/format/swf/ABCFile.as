package format.swf
{
	import flash.utils.ByteArray;
	
	public class ABCFile extends ABCFileStructs
	{
		/*
		abcFile
		{
			u16 minor_version
			u16 major_version
			cpool_info constant_pool
			u30 method_count
			method_info method[method_count]
			u30 metadata_count
			metadata_info metadata[metadata_count]
			u30 class_count
			instance_info instance[class_count]
			class_info class[class_count]
			u30 script_count
			script_info script[script_count]
			u30 method_body_count
			method_body_info method_body[method_body_count]
		}		
		 */
		public var minor_version:uint;
		public var major_version:uint;
		public var constant_pool:Cpool_info;
		public var method_count:uint;
		public var method:Array=new Array;
		public var metadata_count:uint;
		public var metadata:Array=new Array;
		public var class_count:uint;
		public var instance:Array=new Array;
		public var class_abc:Array=new Array;
		public var script_count:uint;
		public var script:Array=new Array;
		public var method_body_count:uint;
		public var method_body:Array=new Array;
		public function ABCFile(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			minor_version=byte.readUnsignedShort();
			major_version=byte.readUnsignedShort();
			constant_pool=new Cpool_info(byte);
			method_count=readUnsigned30();
			
			for(var i:int=0;i<method_count;i++)
			{
				method.push(new Method_info(byte));
			}
			metadata_count=readUnsigned30();
			for(i=0;i<metadata_count;i++)
			{
				metadata.push(new Metadata_info(byte));
			}
			class_count=readUnsigned30();
			for(i=0;i<class_count;i++)
			{
				instance.push(new Instance_info(byte));
			}
			for(i=0;i<class_count;i++)
			{
				class_abc.push(new Class_info(byte));
			}
			script_count=readUnsigned30();
			for(i=0;i<script_count;i++)
			{
				script.push(new Script_info(byte));
			}
			method_body_count=readUnsigned30();
			for(i=0;i<method_body_count;i++)
			{
				method_body.push(new Method_body_info(byte));
			}
			
		}
	}
}