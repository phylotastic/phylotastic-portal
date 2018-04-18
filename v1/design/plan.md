# Plan for general-purpose phylotastic interface

All of this could be done from a single interactive web page, with dynamic parts. 

## Step 1. Three input strategies

These are 3 ways of producing a list of valid species names to use in a query for a tree: 

* Choose from a list of pre-existing lists 
   * e.g., pets, hawaiian snakes, crop species
   * we make the lists, so they already contain validated names
   * implementation is easy: make lists, offer a pulldown to choose
* Choose to start with a taxon
   * e.g., carnivora, blattidae 
   * enter taxon name and validate
      * use name-completion or validate with TNRS
   * offer choice to down-sample by at least 3 strategies
      * random choice of species 
      * most important species via Yan's ranking 
      * species with genomes in NCBI
      * species in a geographic region (state, country) via GBIF or lampyr
   * implementation requires widget that interacts with user and external resources
* Choose to extract from a file or URL
   * choose format (PDF, HTML, text)
   * specify source (upload or URL)
   * (security check prior to processing)
   * send to GNRD 
   * display initial list with interface to prune any unwanted names
      * this can just be a list of names, each with a checkbox (default = on)
      * optionally allow names to be added (will require a validation step)

## Step 2. Get tree

* User specifies treestore (TreeBASE, OpenTree source trees, OpenTree synth tree, ToLWeb)
* User specifies any constraints
   * e.g., date of publication, method
   * however, currently it is hard to imagine any constraints that we could implement

## Step 3. Visualize

* Integrate viewer widget to visualize tree 

## Step 4. Extras 

* Option to scale tree using DateLife 
* Option to grab images from EOL 

## Step 5. Export

* Choose file format and export 
