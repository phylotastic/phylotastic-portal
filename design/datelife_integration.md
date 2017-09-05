# re-design of DateLife integration into portal

## Background

DateLife provides date estimates, uncertainties, and scaled trees.  There are three methods currently
* Median tree (default?) - fast method, combines chronograms in DateLife database
* BOLD scaling - slow, on-the-fly scaling using BOLD data
* SDM - slower, supertree method 

## Current design

Currently the portal integrates DateLife scaling silently when tree is requested.  

## Possibilities 

Obvious issues to address: 
* (DateLife) metadata describing DateLife scaling
* (Portal) exposing options to user 
* (Portal) exposing metadata to user

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

