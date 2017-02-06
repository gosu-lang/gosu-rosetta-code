uses java.awt.*
uses java.awt.event.*
uses java.util.Random
uses javax.swing.*

public class FifteenPuzzle extends JPanel  {

  static final var numTiles = 15
  static final var side  = 4
  var rand = new Random()
  var tiles = new int[numTiles + 1]
  var tileSize : int
  var blankPos : int
  var margin : int
  var gridSize : int
  
  public construct() {
    var dim = 640
    margin = 80
    tileSize = (dim - 2 * margin) / side
    gridSize = tileSize * side
    PreferredSize = new Dimension(dim, dim)
    Background = Color.white
    Foreground = new Color(6591981)
    Font = new Font("SansSerif", Font.BOLD, 60)
    addMouseListener(new MouseAdapter() {

      override public function mousePressed(e : MouseEvent) : void {
        var ex = e.getX() - margin
        var ey = e.getY() - margin
        if (ex < 0 or ex > gridSize or ey < 0 or ey > gridSize) {
          return
        }
        var c1 = ex / tileSize
        var r1 = ey / tileSize
        var c2 = blankPos % side
        var r2 = blankPos / side
        if ((c1 == c2 and Math.abs(r1 - r2) == 1) or (r1 == r2 and Math.abs(c1 - c2) == 1)) {
          var clickPos = r1 * side + c1
          tiles[blankPos] = tiles[clickPos]
          tiles[clickPos] = 0
          blankPos = clickPos
        }
        repaint()
      }

    }
    )
    shuffle()
  }

  final function shuffle() : void {
    do {
      reset()
      var n = numTiles
      while (n > 1) {
        n--
        var r = rand.nextInt(n)
        var tmp = tiles[r]
        tiles[r] = tiles[n]
        tiles[n] = tmp
      }

    }
    while (!isSolvable())
  }

  function reset() : void {
    for (i in 0..|tiles.length) {
      tiles[i] = (i + 1) % tiles.length
    }

    blankPos = numTiles
  }

  function isSolvable() : boolean {
    var countInversions = 0
    var i = 0
    while (i < numTiles) {
      var j = 0
      while (j < i) {
        if (tiles[j] > tiles[i]) {
          countInversions++
        }
        j++
      }

      i++
    }

    return countInversions % 2 == 0
  }

  function drawGrid(g : Graphics2D) : void {
    for (i in 0..|tiles.length) {
      if (tiles[i] == 0) {
        continue
      }
      var r = i / side
      var c = i % side
      var x = margin + c * tileSize
      var y = margin + r * tileSize
      g.setColor(getForeground())
      g.fillRoundRect(x, y, tileSize, tileSize, 25, 25)
      g.setColor(Color.black)
      g.drawRoundRect(x, y, tileSize, tileSize, 25, 25)
      g.setColor(Color.white)
      drawCenteredString(g, String.valueOf(tiles[i]), x, y)
    }

  }

  function drawCenteredString(g : Graphics2D, s : String, x : int, y : int) : void {
    var fm : FontMetrics = g.getFontMetrics()
    var asc = fm.getAscent()
    var dec = fm.getDescent()
    x = x + (tileSize - fm.stringWidth(s)) / 2
    y = y + (asc + (tileSize - (asc + dec)) / 2)
    g.drawString(s, x, y)
  }

  override public function paintComponent(gg : Graphics) : void {
    super.paintComponent(gg)
    var g : Graphics2D = gg as Graphics2D
    g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
    drawGrid(g)
  }
}

SwingUtilities.invokeLater(\->{ 
  var f = new JFrame() {
    :Title = "Fifteen Puzzle",
    :Resizable = true
  }

  f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)
  f.add(new FifteenPuzzle(), BorderLayout.CENTER)
  f.pack()
  f.setLocationRelativeTo(null)
  f.setVisible(true)
})
