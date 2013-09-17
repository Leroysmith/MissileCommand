package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Leroy Smith
	 */
	public class Missile  extends MovieClip
	{
		private var art:MovieClip;
		
		public function Missile() 
		{
			art = new MissileArt();
			addChild(art)
		}
		
	}

}