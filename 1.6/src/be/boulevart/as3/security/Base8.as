package be.boulevart.as3.security { 
	/**
	* Encodes and decodes a base8 (hex) string.
	* @authors Sven Dens - http://www.svendens.be
	* @version 0.1
	*/
	
	public class Base8 {
		/**
		* Encodes a base8 string.
		*/
		public static function encode(src:String):String {
			var result:String = new String("");
	
			for (var i:Number = 0; i<src.length; i++) {
				result += src.charCodeAt(i).toString(16);
			}
			return result;
		}
	
		/**
		* Decodes a base8 string.
		*/
		public static function decode(src:String):String {
			var result:String = new String("");
	
			for (var i:Number = 0; i<src.length; i+=2) {
				result += String.fromCharCode(parseInt(src.substr(i, 2), 16));
			}
			return result;
		}
	}
}