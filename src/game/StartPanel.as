package game
{

	
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import system.loader.Res;
	import system.loader.ResPath;
	import system.loader.LoaderManager;
	import system.ui.Panel;
	import system.DispatchManager;
	import system.ui.BSprite;

	public class StartPanel extends Panel
	{
		
		public static var PANELNAME:String = "startPanel";
		private var _playButton:BSprite;
		private var _la:BSprite;
		private var _bi:BSprite;
		private var _xiao:BSprite;
		private var _xin:BSprite;
		
		override public function onCreate():void{
			LoaderManager.instance().loadRes(ResPath.ROOT+"startpanel/la.png",function (res:Res):void{
				_la = new BSprite((res.data as Bitmap).bitmapData,2);
				
				_la.tx(9+16);
				_la.ty(137);
				addChild(_la);
			});
			LoaderManager.instance().loadRes(ResPath.ROOT+"startpanel/bi.png",function (res:Res):void{
				_bi = new BSprite((res.data as Bitmap).bitmapData,2);
				
				_bi.tx(109+16);
				_bi.ty(154);
				addChild(_bi);
			});
			LoaderManager.instance().loadRes(ResPath.ROOT+"startpanel/xiao.png",function (res:Res):void{
				_xiao = new BSprite((res.data as Bitmap).bitmapData,2);
				_xiao.visible = false;
				_xiao.tx(182+16);
				_xiao.ty(116);
				addChild(_xiao);
			});
			LoaderManager.instance().loadRes(ResPath.ROOT+"startpanel/xin.png",function (res:Res):void{
				_xin = new BSprite((res.data as Bitmap).bitmapData,2);
				
				_xin.tx(272+6);
				_xin.ty(118);
				addChild(_xin);
			});
			LoaderManager.instance().loadRes(ResPath.ROOT+"startpanel/playButton.png",function (res:Res):void{
				_playButton = new BSprite((res.data as Bitmap).bitmapData,2);//145 430
				_playButton.mouseChildren = false;
				
				_playButton.tx(145);
				_playButton.ty(430);
				addChild(_playButton);
				_playButton.mouseChildren = false;
				_playButton.addEventListener(MouseEvent.MOUSE_DOWN,function ():void{
					AnimationManager.Scale(_playButton);
					DispatchManager.dispatch(GameEvent.CLICK_STARTPANEL_PLAY);
				});
			});
		}
		
		
		
		override public function onStart():void{
			_la.visible = false;
			_bi.visible = false;
			_xin.visible = false;
			_playButton.visible = false;
			
			var labixiaoxin:Array = [_la,_bi,_xiao,_xin];
			var stime:Number = 0;
			for(var i:Number = 0;i<labixiaoxin.length;++i){
					AnimationManager.dropAndScale(labixiaoxin[i],stime+=0.3);
			}
			AnimationManager.dropAndScale(_playButton,stime+=0.7);
			
			
		}
		
		override public function reLayout():void{
			var point:Point = Game.instance().getPosition();
			this.x = point.x;
			this.y = point.y;
		}
		
		override public function getResUrl():Array{
			var resUrl:Array = [];
			resUrl.push(ResPath.ROOT+"startpanel/la.png");
			resUrl.push(ResPath.ROOT+"startpanel/bi.png");
			resUrl.push(ResPath.ROOT+"startpanel/xiao.png");
			resUrl.push(ResPath.ROOT+"startpanel/xin.png");
			resUrl.push(ResPath.ROOT+"startpanel/playButton.png");
			return resUrl;
		}
		
		protected function onComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			this.addChild(loaderInfo.content);
			this.scrollRect = new Rectangle(0,0,this.width,this.height);
			if(Game.instance().stageW()>this.width){
				this.x = (Game.instance().stageW() - this.width)>>1;
			}
			
		}		
		
	}
}