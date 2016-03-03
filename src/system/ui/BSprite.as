package system.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class BSprite extends Sprite
	{
		private var _bitmap:Bitmap;
		private var _tracingPointLocation:Number = 0;
		
		public function BSprite(bmd:BitmapData = null,tracingPointLocation:int = 0)
		{
			super();
			_bitmap = new Bitmap();
			_bitmap.bitmapData = bmd;
			addChild(_bitmap);
			setTracingPoint(tracingPointLocation);
		}
		
		public function tx(x:Number):void{
			switch(_tracingPointLocation){
				case 2:
					this.x = x + _bitmap.width/2;
					break;
				default:
					break;
			}
		}
		
		public function ty(y:Number):void{
			switch(_tracingPointLocation){
				case 2:
					this.y = y + _bitmap.height;
					break;
				default:
					break;
			}
		}
		
		public function getW():Number{
			return _bitmap.width;
		}
		
		public function getH():Number{
			return _bitmap.height;
		}
		
		public function setTracingPoint(location:int):void{
			switch(location){
				case 2:
					_bitmap.y=0-_bitmap.height;
					_bitmap.x = 0-_bitmap.width/2;
					break;
				default:
					break;
			}
			_tracingPointLocation = location;
		}
		
	}
}