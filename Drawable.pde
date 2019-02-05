public interface Drawable {
  float getLevel();
  void draw();
}

public class DrawableComparator implements Comparator<Drawable>
{
  @Override
    public int compare(Drawable x, Drawable y)
  {
    if (x.getLevel() < y.getLevel())
    {
      return -1;
    }
    if (x.getLevel()> y.getLevel())
    {
      return 1;
    }
    return 0;
  }
}
