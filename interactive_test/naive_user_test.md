# User test results 

## User test 1

teachable moments.  

### Background

October 7, 4:05 to 4:40 pm.  User is a grad student with a biochemistry background.  The test took about 35 minutes total including instructions, 20 minutes of observation, explanations, and a brief post-test discussion.  Errors in the portal service prevented this from being a complete test. Recorded video was discarded after analysis.  

### Issues and comments from post-test discussion 
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
   * compose default filename from list name. e.g., "word1_word2_phylotastic_list.txt")
* list view enhancement 203
   * scientific name is unfamiliar, unrevealing
   * float-over name to show common name, thumbnail? 
   * show common name, thumbnail in list itself; mouse over thumbnail to expand
* Birds vs. Reptiles list
   * change name to something with a clearer significance
   * Fill out description.  Include questions, e.g., "What is the relationship of birds and mammals to reptiles?"  Write an explanation at the 10th-grade level.  
* Relocate "Get tree" button 
   * consider flow of operations. 
   * user is looking to left or right for next step
   * can we give a title to the lower right menu and put it there?  Current List Actions  
* user expects top left logo to go somewhere
   * should point to phylotastic.org
* users expect view to be modified without clicking "Apply" 
   * strengthen the visual link between the controls and the "Apply" button 
* note: allow user to test with their own set-up
* unexplained problem.  Safari 9.3 user, anonymous mode, extract from web feature: fading banner with feedback does not appear.  User navigates away.  I have tested this and I cannot reproduce the original behavior, but I know why the list was lost.  This is a separate issue.  
* Lost list in anonymous mode.  Extract from web in anonymous mode.  This creates a list.  Click on Tree view, then back to List view.  List is gone because there is no way to save.  
* extract from web message: too subtle.  fades too quickly.  
* fix routing after "Edit list" (edit list name)
   * open list in Home
   * click "Edit list" (edit list name)
   * change name, or not
   * view goes back to the welcome message --> should show original list instead
* special characters not displaying in taxon matching report
   * extract from web using from https://en.wikipedia.org/wiki/Wombat
   * look at taxon matching report
* taxon matching report header
   * fill in value of TNRS
* Choose from taxon feedback needed
   * add progress bar or other indicator when processing a long list of species
* Choose from taxon - embedded docs and styling
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
* make all click-boxes twice the size that they are now
* Get tree feedback: report to user how many taxa were found
* tree node actions
   * don't make some options bold, others not: users think this means bold = available, not = unavailable 
* tip alignment 
   * make tree branches extend out to names
   * short branches are too short-- find a way to make them longer 
* changes to leaf-node actions
   * fonts
      * enlarge by 2 points
      * title in bold, others not in bold
   * title: "Medicago sativa" actions (use leaf name)
   * item 1 (EOL link): "Read info page"
   * items 2 to 4 should be toggles 
   * item 2: "Add (remove) photo"
   * item 3: "Add (remove) box"
   * item 4: "Thick (thin) branch"
* changes to internal node actions
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
* ETE node actions feedback. 
   * issue
      * mouse-down on node to get menu
      * implicated node is enlarged *very slightly*.  this is too subtle.  
   * easy fix: enlarge it more 
   * harder fix: make a reference triangle with one vertex on the node, and the other vertices at the top corners of the pop-up menu. 

* tree render enhancement: add "Color branches" with pop-up to choose color

   * 

note: 
* minute 4 on Cyndy's audio on importance of feedback
* minute 5:19 bold, not bold thing
cover crops list: https://plants.usda.gov/java/coverCrops

### Notable events and issues in the recorded session 
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