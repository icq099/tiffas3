package yzhkof.util
{
	import flash.sampler.DeleteObjectSample;
	import flash.sampler.NewObjectSample;
	import flash.sampler.Sample;
	import flash.sampler.clearSamples;
	import flash.sampler.getSamples;
	import flash.sampler.pauseSampling;
	import flash.sampler.startSampling;
	import flash.utils.Dictionary;
	
	public class SampleUtil
	{
		private static var newSampleMap:Dictionary=new Dictionary;
		public function SampleUtil()
		{
		}
		public static function getSample(obj:Object):NewObjectSample
		{
			updataSample();
//			var samples:Object=getSamples();
//			for each(var i:Sample in samples)
//			{
//				if(i is NewObjectSample)
//				{
//					if(NewObjectSample(i).object==obj)
//					{
//						startSampling();
//						return i as NewObjectSample;
//					};
//				}
//			}
//			startSampling();
//			return null;
			for each (var i:NewObjectSample in newSampleMap)
			{
				if(i.object==obj)
				{
					return i;
				}
			}
			return null;
		}
		public static function getInstanceCreatPath(obj:Object):String
		{
			var sample:NewObjectSample=getSample(obj);
			var re_str:String="无样本！";
			if(sample)
			{
				re_str="";
				var l:uint=sample.stack.length;
				for(var i:int=0;i<l;i++)
				{
					re_str+=sample.stack.shift()+"\n";	
				}
			}
			return re_str;
		}
		private static function updataSample():void
		{
			pauseSampling();
			var samples:Object=getSamples();
			//var length_s:uint=0
			for each(var i:Sample in samples)
			{
//				length_s++
				if(i is NewObjectSample)
				{
					newSampleMap[NewObjectSample(i).id]=i;
				}else if(i is DeleteObjectSample)
				{
					delete newSampleMap[DeleteObjectSample(i).id];	
				}else
				{
					trace(i.stack);	
				}
			}
			//trace(length_s);
			clearSamples();
			startSampling();
		}

	}
}