import com.ludamix.triad.ui.CascadingText;
import com.ludamix.triad.ui.Rect9;
import com.ludamix.triad.ui.Helpers;
import nme.Assets;
import nme.text.TextFormatAlign;

class CommonStyle
{
	
	public static var rr : Rect9Template;
	public static var rrDown : Rect9Template;
	public static var fielddata : Dynamic;
	public static var formatdata : Dynamic;
	public static var cascade : CascadingTextDef;
	public static var styleUp : LabelRect9Style;
	public static var styleDown : LabelRect9Style;	
	public static var basicButton : LabelButtonStyle;
	
	public static function init()
	{
		rr = new Rect9Template(Assets.getBitmapData("assets/frame.png"), 8, 8, 32, 32);
		rrDown = new Rect9Template(Assets.getBitmapData("assets/frame2.png"), 8, 8, 32, 32);
		
		fielddata = { text:"Hello World", selectable:false };
		formatdata = { align:TextFormatAlign.CENTER };
		cascade = {field:[fielddata],format:[formatdata]};
		styleUp = {cascade:cascade, rect9 : rr };
		styleDown = {cascade:cascade, rect9 : rrDown };		
		basicButton = { up:styleUp, down:styleDown, over:styleUp, sizing:BSSPad(8, 8) };
		
	}	
	
}