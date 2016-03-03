package system.loader
{

	public class LoaderListListener
	{
		public var onComplete:Function = null;
		public var onProgress:Function = null;
		public var handler:Function = completeHandler;
		private var _resCount:Number = 0;
		
		public function LoaderListListener(resUrlList:Array,onComplete:Function,onProgress:Function = null)
		{
			_resCount = resUrlList.length;
			this.onComplete = onComplete;
			this.onProgress = onProgress;
		}
		
		private function completeHandler(res:Res):void{
			--_resCount;
			if(onComplete && _resCount==0){
				onComplete(this);
				onComplete = null;
			}
			
		}
	}
}