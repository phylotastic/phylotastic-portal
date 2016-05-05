# portal design 4/19/2016

## To do 

* pick 10 lists 
   * interesting
   * taxonomically diverse
   * at least some with educational value 
   * dinosaur list (not in OT tree)
* get OT tree for 10 lists 
* pick 10 taxa for testing (from 6 to 300 species)
   * Canidae, Felinae, Passerina, 
* get OT tree for 10 taxa 

* make a note that uniprot has common names
* make a note that uniprot has images
* request OT services "number of tips below this node"

## a note about common names 

Search on "common_name taxonomy" sometimes yields uniprot hits. 

Search on "common_name nomenclature" usually reveals binomial in top few hits, unless it is not a species or genus, but something like "beetle" or "fly". 


## Lists 

### Basic workflow 
* user chooses "Lists" workflow
   * system displays choice of lists for user
      * there must be at least 10 interesting lists 
* user chooses a list
   * system retrieves tree, displays for user 
   * system offers option to save to disk or clipboard
* user saves tree 

#### Functional testing 

Normal conditions
* GUI responds as described above 
   * lists at least 10 lists immediately
* tree is displayed within 30 seconds
* expected OT tree is obtained for each list 

Exceptions 
* no tree retrieved for dino list: provide message


### Extra workflows

Edit
* user chooses "Lists" workflow
   * system displays choice of lists for user
* user chooses a list
   * system displays list content with edit option
* user edits lists 
   * system saves edits 
* user selects "get tree" 
   * system retrieves tree, displays for user 

Upload
* user chooses "Lists" workflow
   * system displays choice of lists and option to "Add new"
* user chooses "Add new"
   * system responds with "Add list" view
      * choice to extract taxon names from file with option to edit
      * choice to upload annotated taxon list (Darwin Core Archive)
   * user chooses extract from file or DCA zip file (same for both)
      * [system prompts for file name, user responds]
      * [system uploads file, extracts names, presents to user]
      * [user has option to edit list]
      * user chooses "Save list" 
         * system returns to "Lists" view
   * system shows new list in "My lists"
* user chooses newly added list 
   * system retrieves tree, displays for user 

## Choose from taxon 

### Basic workflow with 2 branches

* user chooses "Taxon" workflow
   * system prompts for taxon name 
      * provides helpful hints (see above)
* user enters name, e.g., "Canidae"
   * system prompts for choice of 
      * all species 
      * species with genomes in NCBI
* user chooses all species or genomes
   * system retrieves list, gets tree, displays for user 

#### Functional testing 

* GUI responds as described above 
* hints are helpful to get binomials from common names
* tree is displayed within 30 seconds
* expected tree is obtained for each list 

### Additional workflows 

Option to edit list 
* user chooses "Taxon" workflow
   * system prompts for taxon name 
* user enters name, e.g., "Canidae"
   * system prompts for choice of 
      * all species 
      * species with genomes in NCBI
* user chooses all species or genomes
   * system retrieves list, displays list editor, prompts user to edit or accept
* user optionally edits 
* user accepts list
   * system gets tree, displays for user 
   
## Acquire names from source 

### Basic workflows 

Basic from URL
* user chooses "Extract from source" workflow
   * system prompts for source (URL or file upload)
* user enters URL 
   * system extracts names, gets tree, displays to user 
   
Basic from file 
* user chooses "Extract from source" workflow
   * system prompts for source (URL or file upload)
* user uploads file  
   * system extracts names, gets tree, displays to user 

### Additional workflows 

Option to edit list (URL)
* user chooses "Extract from source" workflow
   * system prompts for source (URL or file upload)
* user enters URL 
   * system extracts names, prompts user to edit or accept 
* user optionally edits 
* user accepts list
   * system gets tree, displays for user 

Option to edit list (file upload): follow URL example 

