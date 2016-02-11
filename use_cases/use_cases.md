## **USE CASE 1** 
### Extract taxon names from a document and verify the spelling

**Goal**: Extract the names from a document, verify the spelling, list extracted input and corrected spelling, correct the input document 

Author/User provides the file

* Main Success Scenario: 
     * 1. User inputs their document
     * 2. System provides list of extracted names from the document
     * 3. User views/confirms the extracted list
     * 4. System provides the correct spelling of the names
     * 5. User views/accepts the correctly spelled names
     * 6. System provides list of all names
     * 7. User accepts this final list
     * 8. User authorizes the system to correct the names in the document inputted
     * 9. System notifies user of the changes in document

* Stakeholders: 
     * Authors
     * Publisher
     * Community

* Extensions
     * 3. Add missing names that the scraper didn’t catch.
     

## **USE CASE 2**

### Extract names from a document and provide taxonomical authority

**Goal**: Extract the names from a document and provide the taxonomic authority according to the correct Nomenclature Code

* Main Success Scenario:
     * 1. User inputs their document
     * 2. User restricts the search to a distinct Nomenclature Code (ICN, ICNP, ICZN,   ICTV)
     * 3. System extracts names
     * 4. System matches these names to taxonomic authority
     * 5. System provides list of extracted names and their taxonomic authority
     * 6. User accepts this list
     * 7. System adds these authorities to the input document
     * 8. System notifies user of the changes in the document

* Stakeholders
     *	Authors
     *	Publishers

* Extensions
     * 1. Author suggests nomenclature authority.
     * 2. Multiple authorities can be used.
     * 7. Alternative: Provide a detailed list
     * 8. Resubmit to check again

 

## **USE CASE 3**

### Extract names of an input to a restricted focal clade

**Goal**: Extract names from a document/url restricted to a focal taxon and provide this list to the user

* User inputs a document or url

* Main Success Scenario:
     * 1. User inputs a document or URL link
     * 2. User restricts to a focal clade 
     * 3. System provides all those taxa within the focal clade as a list

* Stakeholders:
     * Authors
     * Grade school teachers
     * Community
     * Phylotastic Project (EOL)
     * Community that wants to focus on a specific area of a species list
          * e.g. A researcher has a plant list of NA plants, but wants to focus only on the Asteraceae to verify if they have a new citation for NA.


## **USE CASE 4**

### Extract taxon names and provide synonyms with their respective authority and reference

**Goal**: Extract names from a document, verify if these are valid names, and provide the synonyms 

* User inputs a document

* Main Success Scenario:
     * 1. User inputs a document
     * 2. User restricts the Nomenclature Code to search
     * 3. System extracts taxa
     * 4. System provides list of synonyms of each extracted taxon
     * 5. System verifies which name is presently valid
     * 6. System provides taxonomic authority for all taxa
     * 7. System provides reference to these authorities

* Stakeholders
     * Authors
     * Publishers
     * Community
