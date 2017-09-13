# re-design of DateLife integration into portal

## Background

DateLife provides date estimates, uncertainties, and scaled trees.  There are three methods currently
* Median tree (default?) - fast method, combines chronograms in DateLife database
* BOLD scaling - slow, on-the-fly scaling using BOLD data
* SDM - slower, supertree method 

## Issues with current Portal implementation

* DateLife invoked automatically, invisibly.  User does not have control.  
* Metadata describing scaling is missing.  
* Datelife options are not exposed. 

Also, the current version of DateLife allows some interesting possibilities, e.g., quietly query DateLife for tree using SDM, then test to see if it has more nodes (better resolved); if so, notify user that a more resolved tree is available

## Possibilities 

Obvious issues to address: 
* (DateLife) metadata describing DateLife scaling
   * Design and implement metadata description to accompany DateLife WS output
* (Portal) exposing metadata to user
   * ingest DateLife metadata and fold it into tree metadata presented to user 
* (Portal) exposing options to user 
   * expose DateLife options to user
   * allow user to choose whether or not to use DateLife at all.  

That is, the Portal provides user with access to DateLife options, DateLife reports on its methods, and this report is included in the metadata for the tree.  

The simplest way to incorporate options is to provide them explicitly in a stereotyped workflow, e.g., 
1. choose taxa
1. get tree
1. choose scaling method 

However, DateLife makes it possible to consider other options
1. choose taxa
1. get tree
1. query if DateLife tree provides better resolution 

This kind of querying could be carried out in the background while the user is examining initial output.  

