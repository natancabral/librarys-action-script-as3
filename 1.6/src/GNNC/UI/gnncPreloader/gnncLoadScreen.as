package GNNC.UI.gnncPreloader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	
	public class gnncLoadScreen extends Loader {

		//~ Settings ----------------------------------------------------------
		private static var _BarWidth     : int = 153;  // Progress bar width
		private static var _BarHeight    : int = 12;   // Progress bar height
		private static var _LogoHeight   : int = 153;   // Logo picture height
		private static var _LogoWidth    : int = 68;  // Logo picture width
		private static var _Padding      : int = 5;   // Spacing between logo and progress bar
		private static var _LeftMargin   : int = 0;    // Left Margin
		private static var _RightMargin  : int = 0;    // Right Margin
		private static var _TopMargin    : int = 1;    // Top Margin
		private static var _BottomMargin : int = 1;    // Bottom Margin
		
		private static var _BarBackground  : uint = 0x000000; // background of progress bar
		private static var _BarOuterBorder : uint = 0x000000; // color of outer border
		private static var _BarColor       : uint = 0x000000; // color of prog bar
		private static var _BarInnerColor  : uint = 0x000000; // inner color of prog bar
		
		//~ Instance Attributes -----------------------------------------------
		[Embed(source="image/splash2012.gif")]
		private var _logoClass: Class;
		private var _logo : Bitmap;
		private var _logoData : BitmapData;
		
		private var isReady  : Boolean = false;
		public  var progress : Number;
		
		//~ Constructor -------------------------------------------------------        
		public function gnncLoadScreen()
		{
			super();
			this.progress = 0;
			this._logo = new _logoClass as Bitmap;
		}
		
		//~ Methods -----------------------------------------------------------
		public function refresh() : void
		{
			this._logoData = this.draw();
			var encoder : PNGEncoder = new PNGEncoder();
			var bytes   : ByteArray  = encoder.encode(this._logoData);
			this.loadBytes(bytes);
		}
		
		override public function get width() : Number
		{
			return Math.max(_BarWidth, _LogoWidth) + _LeftMargin + _RightMargin;
		}
		
		override public function get height() : Number
		{
			return _LogoHeight + _BarHeight + _Padding + _TopMargin + _BottomMargin;
		}
		
		private function draw() : BitmapData
		{
			// create bitmap data to create the data
			var data : BitmapData = new BitmapData(this.width, this.height, true, 0);
			
			// draw the progress bar
			var s : Sprite = new Sprite();
			var g : Graphics = s.graphics;
			
			// draw the bar background
			g.beginFill(_BarBackground);
			g.lineStyle(2, _BarOuterBorder, 1, true);
			var px : int = (this.width - _BarWidth) / 2;
			var py : int = _TopMargin + _LogoHeight + _Padding;
			g.drawRoundRect(px, py, _BarWidth, _BarHeight, 2);
			var containerWidth : Number = _BarWidth - 4;
			var progWidth : Number = containerWidth * this.progress / 100;
			g.beginFill(_BarColor);
			g.lineStyle(1, _BarInnerColor, 1, true);
			g.drawRect(px + 1, py + 1, progWidth, _BarHeight - 3);
			data.draw(s);
			
			// draw the logo
			data.draw(this._logo.bitmapData, null, null, null, null, true);
			return data;
		}
		
		public function set ready(value : Boolean) : void
		{
			this.isReady = value;
			this.visible = !this.isReady;
		}
		
		public function get ready() : Boolean { return this.isReady; }
		
	}
}