package be.boulevart.as3.security { 
	/**
	* Encodes and decodes a base64 string.
	* @authors Sven Dens - http://www.svendens.be
	* @version 0.1
	*
	* Original Javascript implementation:
	* Aardwulf Systems, www.aardwulf.com
	* See: http://www.aardwulf.com/tutor/base64/base64.html
	*/
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	
	public class Base64 {
		/**
		* Variables
		* @exclude
		*/
		protected static var base64chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

		/**
		* Encodes a base64 string.
		*/
		public static function encode(src:String):String 
		{
			var i:Number = 0;
			var output:String = new String("");
			var chr1:Number, chr2:Number, chr3:Number;
			var enc1:Number, enc2:Number, enc3:Number, enc4:Number;
			while (i < src.length) {
				chr1 = src.charCodeAt(i++);
				chr2 = src.charCodeAt(i++);
				chr3 = src.charCodeAt(i++);
				enc1 = chr1 >> 2;
				enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
				enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
				enc4 = chr3 & 63;
				if(isNaN(chr2)) enc3 = enc4 = 64;
				else if(isNaN(chr3)) enc4 = 64;
				output += base64chars.charAt(enc1)+base64chars.charAt(enc2);
				output += base64chars.charAt(enc3)+base64chars.charAt(enc4)
			}
			return output;
		}
	
		/**
		* Decodes a base64 string.
		*/
		public static function decode(src:String):String 
		{
			var i:Number = 0;
			var output:String = new String("");
			var chr1:Number, chr2:Number, chr3:Number;
			var enc1:Number, enc2:Number, enc3:Number, enc4:Number;
			while (i < src.length) {
				enc1 = base64chars.indexOf(src.charAt(i++));
				enc2 = base64chars.indexOf(src.charAt(i++));
				enc3 = base64chars.indexOf(src.charAt(i++));
				enc4 = base64chars.indexOf(src.charAt(i++));
				chr1 = (enc1 << 2) | (enc2 >> 4);
				chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
				chr3 = ((enc3 & 3) << 6) | enc4;
				output += String.fromCharCode(chr1);
				if (enc3 != 64) output = output+String.fromCharCode(chr2);
				if (enc4 != 64) output = output+String.fromCharCode(chr3);
			}
			return output;
		}

		/**
		 * Encodes a base64 string.
		 */
		public static function encode2(src:String):String 
		{
			var i:Number = 0;
			var output:String = new String("");
			var chr1:Number, chr2:Number, chr3:Number;
			var enc1:Number, enc2:Number, enc3:Number, enc4:Number;
			while (i < src.length) {
				chr1 = src.charCodeAt(i++);
				chr2 = src.charCodeAt(i++);
				chr3 = src.charCodeAt(i++);
				enc1 = chr1 >> 2;
				enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
				enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
				enc4 = chr3 & 63;
				if(isNaN(chr2)) enc3 = enc4 = 64;
				else if(isNaN(chr3)) enc4 = 64;
				output += base64chars.charAt(enc1)+base64chars.charAt(enc2);
				output += base64chars.charAt(enc3)+base64chars.charAt(enc4)
			}
			return output;
		}
		
		/**
		 * Decodes a base64 string.
		 */
		public static function decode2(src:String):String 
		{
			var i:Number = 0;
			var output:String = new String("");
			var chr1:Number, chr2:Number, chr3:Number;
			var enc1:Number, enc2:Number, enc3:Number, enc4:Number;
			while (i < src.length) {
				enc1 = base64chars.indexOf(src.charAt(i++));
				enc2 = base64chars.indexOf(src.charAt(i++));
				enc3 = base64chars.indexOf(src.charAt(i++));
				enc4 = base64chars.indexOf(src.charAt(i++));
				chr1 = (enc1 << 2) | (enc2 >> 4);
				chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
				chr3 = ((enc3 & 3) << 6) | enc4;
				output += String.fromCharCode(chr1);
				if (enc3 != 64) output = output+String.fromCharCode(chr2);
				if (enc4 != 64) output = output+String.fromCharCode(chr3);
			}
			return output;
		}
		
		// Compress a ByteArray into a Base64 String.
		public static function compress(bytes:ByteArray):String 
		{ 
			var enc:Base64Encoder = new Base64Encoder();    
			enc.encodeBytes(bytes);
			return enc.drain().split("\n").join("");
		}
		
		// Uncompress a Base64 String into a ByteArray.
		public static function uncompress(str:String):ByteArray 
		{
			var dec:Base64Decoder = new Base64Decoder();
			dec.decode(str);
			var newByteArr:ByteArray=dec.toByteArray();        
			return newByteArr;
		}
		
	}
	
}