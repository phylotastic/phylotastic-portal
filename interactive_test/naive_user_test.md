# User test results 


## Issues added to tracker 

### top priority
* welcome message (#201)
   * don't put DwC-A first 
   * put "if you don't have any lists . . " at the top.  
   * make "web site" the first item in the list, then doc, then taxon, then upload
* download list failure - unexplained bug (#200)
   * go to Home 
   * select Birds vs Reptiles 
   * remove one or two species, or none
   * try "Download .." --> WORKS
   * click "Select/Deselect all" to deselect all
   * click "Select/Deselect all" to select all
   * try "Download .." --> FAILS
* export list as text enhancements (#202)
   * prompt for file-name
   * compose default filename from list name. e.g., "word1\_word2\_phylotastic\_list.txt")
* list view enhancement #203
   * scientific name is unfamiliar, unrevealing
   * float-over name to show common name, thumbnail? 
   * show common name, thumbnail in list itself; mouse over thumbnail to expand
* Relocate "Get tree" button (#205)
   * consider flow of operations. 
   * user is looking to left or right for next step
   * can we give a title to the lower right menu and put it there?  Current List Actions  
* Birds vs. Reptiles list #186
   * change name to something with a clearer significance
   * Fill out description.  Include questions, e.g., "What is the relationship of birds and mammals to reptiles?"  Write an explanation at the 10th-grade level.  
* user expects top left logo to go somewhere #204
   * should point to phylotastic.org
* test with all 4 browsers - chrome, safari, firefox and IE (Arlin, Dail) (#208)
* Lost list in anonymous mode.(#207)  Extract from web in anonymous mode.  This creates a list.  Click on Tree view, then back to List view.  List is gone because there is no way to save.  
* Get tree feedback:(#209) report to user how many taxa were found
* Choose from taxon (#210) - embedded docs and styling
   * change black "(\*)" to red "\*"
   * change prompt from "Taxon name" to "Taxon name (mouse-over for important instructions)" 
   * add mouse-over text that applies both to Taxon name prompt and to input box: "Tax
   * greyed-out text in Taxon name: "e.g., Canidae, Felidae, Balaenoptera"
   * change "Subset by" to *boldfont* "Subset (choose one)" 
   * double the size of the click-boxes
   * remove bold font from "Has genome sequence in NCBI"
   * change "Has genome sequence in NCBI" to "by known genomes"
   * change "Location" to "by country"
   * change "Random subset of" to "at random"
* changes to leaf-node actions (#212)
   * fonts
      * enlarge by 2 points
      * title in bold, others not in bold
   * title: "Medicago sativa" actions (use leaf name)
   * item 1 (EOL link): "Read info page"
   * items 2 to 4 should be toggles 
   * item 2: "Add (remove) photo"
   * item 3: "Add (remove) box"
   * item 4: "Thick (thin) branch"
* changes to internal node actions (#213)
   * fonts
      * enlarge by 2 points
      * title in bold, others not in bold
   * title: 
      * named: Node "Node name" actions 
      * un-named: Node actions
   * item 1: "Collapse subtree"
   * item 2: "Rotate subtree"
   * item 3: "Add (remove) box"
   * item 4: "Thick (thin) branches"
* phylotastic.org services - make titles links (web site #7)
* missing taxon labels: discuss with OTT (phylo_webservices#38)
* non-standard behavior of node actions box (#216)

* names appear twice in extract list - duplicate? 

### medium importance - most not added yet
* Choose from taxon feedback needed - 2 users (#223) 
   * add progress bar or other indicator when processing a long list of species
* "Edit list" (#224)
   * rename to "rename list" 
   * move it somewhere else
* Explain what "ladderize" means (#219)
* hide line highlighting until we can implement it better (#225)
* tip alignment (#226)
   * make tree branches extend out to names
   * short branches are too short-- find a way to make them longer 
* redesign tree viewer control strip - unfinished (#227)
   * names
      * "Line width" --> "Line weight"
      * don't say "download" if it isn't downloaded.  generate image file 
      * "Node labels" --> (add taxon names? "internal node" labels is clearer to most biologists)
   * spacing 
   * sizes 
   * what else?  
* make all click-boxes twice the size that they are now (Van did this already)
* ETE node actions feedback (#228)
   * issue
      * mouse-down on node to get menu
      * implicated node is enlarged *very slightly*.  this is too subtle.  
   * easy fix: enlarge it more 
   * harder fix: make a reference triangle with one vertex on the node, and the other vertices at the top corners of the pop-up menu. 

### lower importance - not added yet
* thumbnail behavior redesign (#218)
* redesign newick export (#222)
* bad cursor in newick box (#221)
* bad focus (firefox) #220
* node box render failure (Firefox) (#217)
* how to emphasize Help (#215)
* review taxize documentation - see what we can use from this project 
* sentence capitalization, e.g., "Line Color" --> "Line color" (#229)
* tree render enhancement: add "Color branches" with pop-up to choose color (#230)
* special characters not displaying in taxon matching report (#231)
   * extract from web using from https://en.wikipedia.org/wiki/Wombat
   * look at taxon matching report
* in Tree view, show rank of taxon labels (#232)
   * capture rank information from OT
   * invent a code kpcofg, o- = suborder, o+ = order.  
   * show rank, e.g., Mammalia (c), Felidae (f), Homininae (f-), Canus (g)
* taxon matching report header (#129)
   * fill in value of TNRS
* fix routing after "Edit list" (edit list name) (#224)
   * open list in Home
   * click "Edit list" (edit list name)
   * change name, or not
   * view goes back to the welcome message --> should show original list instead
* extract from web message: too subtle.  fades too quickly. (#225) 
* users expect view to be modified without clicking "Apply" (#227)
   * strengthen the visual link between the controls and the "Apply" button 
* unexplained problem.  Safari 9.3 user, anonymous mode, extract from web feature: fading banner with feedback does not appear.  User navigates away.  I have tested this and I cannot reproduce the original behavior, but I know why the list was lost.  This is a separate issue.  


## User test 1

### Background on user test 1

October 7, 4:05 to 4:40 pm.  User is a grad student with a biochemistry background.  The test took about 35 minutes total including instructions, 20 minutes of observation, explanations, and a brief post-test discussion.  Errors in the portal service prevented this from being a complete test. Recorded video was discarded after analysis.  

### Notable events and issues in the recorded session with user 1
* (0:07) good.  user goes right to the welcome message
* (0:25) "whats the DwC-A?" 
* (1:22) user clicks “download list”; no feedback; user clicks again (1:30); no feedback; user is confused, asks, clicks again; no feedback
* (1:46) metadata Description field of public list is empty
* (1:54) user is clicking on names (she explains later that she expects to click through to an info page on species), but the effect is only to select or deselect the row
   * add info link to EOL.  
* (2:07) user does not realize immediately where is the Get Tree button.  Explains that it is not in either the left or right menu area. 
* (2:40) tree fails.  no feedback.  user is confused.  
* (3:24) user tries and fails to select node labels button 3 times before succeeding on the 4th try
   * button is too small: make button larger
* (3:30) notice how user responds to lack of feedback about tree-view failure
* (4:10) observer interrupts, explains failure of tree viewer 
* (6:20) why does list not appear?  user tries to get list, no feedback.  we do not know what happened here.  this is not blocked  
* (6:23) note that when user moves to Trees, the list will be lost.  
* (11:44) user appreciates that the URL is saved in metadata

### Background on user tests 2 and 3

Both government scientists in biodiversity area at USDA.  

### Notable events and issues in the recorded session with user 2
* minute 4 importance of feedback
* minute 5:19 bold, not bold thing is directly confusing to user 
* example: cover crops list: https://plants.usda.gov/java/coverCrops
* 14:26.  user wants to highlight species with a particular phenotype.  "invasives" or "problems". Let's get back to user: if you had to get this info by a robot or a program, what resource would you use, and how would you extract it?  This could be an example of searchable species data that we might want to put on a list.  

### Notable events and issues in the recorded session with user 3

* 3:35 Public list is full of junk from anonymous users, confusing to new user 
* 4:00 user faces option to log in.  doesn't like it. says "I don't necessarily want to associate my google account with this . . . so let's see what else we can do".  
* 5:00 user is waiting for "choose taxon" to complete with query "hexapoda" and no subsetting.  we ask him what he expects.  he expects to see a progress bar.  is this network problem?  or is it working? 
* 8:00 this user figures out the "Apply" button with no hesitation
* 8:25 don't know what "ladderize" trees means
* 10:40 user wants app to show the rank of taxon names
* 12:30 why doesn't the genus label always appear on a subtree for a genus?  
* 13:00 user looks at help for the first time "Oh, here we go"
* 16:30 some issues with click-boxes.  users suspects they do not work, but I'm not so sure.  I think it was just that they are too small. 
* 18:44 node actions box does not disappear if user clicks outside.     I checked and this also happens on Safari and Chrome.
* 19:04 node box failure: list items extend outside of box.  FireFox 48.0.1 on OSX 10. "This looks like a CSS thing" says the user, in case that is helpful.  
* 20:05 user expects to click on image and go somewhere, or see enlarged picture
* 20:30 it is drawing the box outside of the area currently in view. over-ride browswer
* 22:17  FireFox 48.0.1 on OSX 10, user can't select and copy tree with mouse or using cmd-a.  The problem is that the focus is not in the export Newick box.  Choosing cmd-a from the keyboard (select all) selects text in the Tree view not in the Newick box.  This does not occur in other browsers.  This is not a show-stopper because the user can still click "copy" or "export" to get the information.  
* 22:17 in export Newick box, cursor appears with icon that seems to indicate selecting is not possible.  However, selecting *is* possible in Chrome or Safari.  See Firefox for a separate issue on this.  
* 22:59 confusing messages.  "Export as TXT" with sub-items "WITH ottids" and "WITHOUT ottids".  User does not know what OTT Ids, so he doesn't know whether or not he has them already.  I like what I see (the Newick string currently showing) but I don't know if it is the right thing.  Change export as txt to "Save".  Add check box to include OpenTree IDs with float-overs.  In a future version, we may add the capacity for other kinds of IDs.  