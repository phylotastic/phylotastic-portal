# targets 

## Priority level 1
* shows clean square trees, economical with space
   * use space_test.nwk, display in < 8 vertical inches
* capacity up to 500 easily displayed 
   * use capacity_test.nwk, display and navigate in < 2 seconds
* ability to display images on tips
   * use viz_sample7.nwk with thumbnails in images/
* ability to display terminal node information and link-outs
   * use viz_sample7.nwk with links in URL column of viz_sample7_data.csv
* control tip alignment
   * use space_test.nwk, show with and without tips aligned to the right
* control line thickness and color
   * use viz_sample7.nwk with thin or thick lines
* export high-resolution graphics image
   * use capacity_test.nwk, save in resolution high enough to enlarge so that names are easily readable.  For successful example, see capacity_test.svg; unsuccessful example is capacity_test.jpg (resolution too low).   
* supports a way to highlight clade
   * indicate "Cervidae" in viz_sample7.nwk
   * use vertical bar or curly brace, or enclose in colored rectangle
* supports a way to distinguish multiple clades
   * indicate "Cervidae" and "Bovidae" in viz_sample7.nwk
* align tips with data table 
   * show viz_sample7.nwk with categorical data in trophic habit column of viz_sample7_data.csv 
   * show viz_sample7.nwk with numeric data in body mass column of viz_sample7_data.csv 
   
## Priority level 2 features 
* ladderize
   * show ladder_test.nwk with and without ladderization
* ability to associate information with internal node 
   * show "Cervidae" label on ancestral Cervidae node 
   * can be static or dynamic (float-over)
* ability to associate information with branch 
   * show label "7 events" on branch leading to Cervidae  
   * can be static or dynamic (float-over)
* export annotated tree in portable tree format (e.g., NeXML, NHX, PhyloXML)
   * ???
* export vector graphics image
   * use capacity_test.nwk, see capacity_test.svg .    
* collapse clades
   * use viz_sample7.nwk, collapse Carnivora 
* re-order clades
   * use viz_sample7.nwk, swap Cervidae and Bovidae

## Priority level 3 features 
* some way to view larger trees (dynamic expansion, fish-eye, fractal, etc)
* ability to serve as arbitrary controller
* ability to combine phylogeny with geographic locations on a map


## needed 

* ladderize tree
 
