const GoogleDictionaryURL = "https://www.google.com/search?q=google+dictionary";
const VocabularyURL = "https://www.vocabulary.com/dictionary";
const FreeDictionaryURL = "https://www.thefreedictionary.com";

const GoogleDictionaryJSChannelName = "GoogleDictionary";
const VocabularyJSChannelName = "Vocabulary";
const FreeDictionaryJSChannelName = "FreeDictionary";

const GoogleDictionaryJS =
    """
    /**
     * Remove unwanted elements to clean things up
     */

    if (document.getElementById("sfooter"))
        document.getElementById("sfooter").style.display = "none";

    if (document.getElementById("extrares"))
        document.getElementById("extrares").style.display = "none";

    if (document.getElementById("taw"))
        document.getElementById("taw").style.display = "none";

    if (document.getElementById("qslc"))
        document.getElementById("qslc").style.display = "none";

    if (document.getElementById("msc"))
        document.getElementById("msc").style.display = "none";

    if (document.getElementById("sfcnt"))
        document.getElementById("sfcnt").style.display = "none";
        
    if (document.getElementById("botstuff"))
        document.getElementById("botstuff").style.display = "none";

    let wordCoach = document.querySelector("[jsname=tEutQe]")
    if (wordCoach != null) wordCoach.style.display = "none";

    let ads1 = document.getElementsByClassName("KojFAc")
    if (ads1.length > 0) {
        document.getElementsByClassName("KojFAc")[0].style.display = "none";
    }

    let ads2 = document.getElementsByClassName("XqIXXe")
    if (ads2.length > 0) {
        document.getElementsByClassName("XqIXXe")[0].style.display = "none"
    }

    let ads3 = document.getElementsByClassName("u0jb6e")
    if (ads3.length > 0) {
        document.getElementsByClassName("u0jb6e")[0].style.display = "none";
    }
    
    let qna = document.querySelector('[data-md="355"]')
    if (qna != null) {
        qna.style.display = "none";
    }
    
    let dictionaryResult = document.getElementsByClassName("kp-wholepage ss6qqb mnr-c kp-wholepage-osrp EyBRub")
    if (dictionaryResult.length > 0) {
        dictionaryResult[0].style.display = "none";
    }

    let apps = document.getElementsByClassName("qs-io aig-lst")
    if (apps.length > 0) {
        apps[0].style.display = "none";
    } 

    let searchResults = document.getElementsByClassName("g kno-result rQUFld kno-kp mnr-c g-blk")
    for (var i = 0; i < searchResults.length; i++) {
        searchResults[i].style.display = "none";
    }

    let searchResults2 = document.getElementsByClassName("srg")
    for (var i = 0; i < searchResults2.length; i++) {
        searchResults2[i].style.display = "none";
    }

    let searchResults3 = document.getElementsByClassName("mnr-c xpd O9g5cc uUPGi")
    for (let result of searchResults3) {
        result.style.display = "none";
    }

    if (document.getElementById("center_col"))
        document.getElementById("center_col").style.paddingTop = '16px';


    var searchBar = document.getElementsByClassName('YaTjLb')[0] //always available combo box
    searchBar.click()
    searchBar.style.display = "none";

    var input = document.querySelector('#sb_ifc50 > input')
    const enterKey = new KeyboardEvent("keydown", {
            bubbles: true, cancelable: true, keyCode: 13
    });

    function onFullDefinitionClicked() {
      let word = document.querySelector('[jsname=NwvD9c]').innerText

      //let the app know that user is now navigating to this word
      $GoogleDictionaryJSChannelName.postMessage(word);
      let closeButton = document.querySelector('[jsaction="trigger.dBhwS"]')
      closeButton.click()

      //now search word
      let input = document.querySelector('#sb_ifc50 > input')

      input.value = word
      input.dispatchEvent(new KeyboardEvent("keydown", {
        bubbles: true, cancelable: true, keyCode: 13
      }));
    }

    function setupFullDefinitionButton() {
        let fullDefinitionButton = document.querySelector('[jsaction="trigger.Lesnae"]')
        fullDefinitionButton.setAttribute("jsaction", "") //disable its functionality
        fullDefinitionButton.onclick = onFullDefinitionClicked
    }
    
    let oldXHROpen = window.XMLHttpRequest.prototype.open;
    window.XMLHttpRequest.prototype.open = function(method, url, async, user, password) {
      this.addEventListener('load', function() {
        /**
         * Called when an XHR request is completed
         */
         
        let el1 = document.getElementsByClassName("duf3");
        for (var i = 0; i < el1.length; i++) {
          el1[i].style.display = "none";
        }
        
        let el2 = document.getElementsByClassName("iXqz2e aI3msd xpdarr mv83Pc pSO8Ic vk_arc");
        for (var i = 0; i < el2.length; i++) {
          el2[i].style.display = "none";
        }
        
        let el3 = document.getElementsByClassName('YaTjLb');
        for (var i = 0; i < el3.length; i++) {
          el3[i].style.display = "none";
        }
        
        let el4 = document.getElementsByClassName("lr_dct_ent vmod XpoqFe");
        for (var i = 0; i < el4.length; i++) {
          el4[i].style.paddingTop = '0px';
        }
        
        let wordCoach = document.querySelector("[jsname=tEutQe]")
        if (wordCoach != null) wordCoach.style.display = "none";
        
        setTimeout(setupFullDefinitionButton, 200)
      });
       
      return oldXHROpen.apply(this, arguments);
    }
    123;
    """;

const VocabularyJS =
    """
    let e1 = document.getElementById('google_ads_iframe_/15665503/Dictionary-Result-Right_0');
    if (e1) e1.outerHTML = ""
      
    let e2 = document.getElementsByClassName('leaderboard-ad')[0]
    if (e2) e2.style.display = 'none';
    
    let e3 = document.getElementsByClassName("page-header noselect")[0]
    if (e3) e3.style.display = "none";
    
    let e4 = document.getElementsByClassName("fixed-tray")[0]
    if (e4) e4.style.display = "none";
    
    let e5 = document.getElementById("dictionaryNav")
    if (e5) e5.style.display = "none";
    
    let e6 = document.getElementsByClassName("signup-tout center clearfloat sectionbg")[0]
    if (e6) e6.style.display = 'none';
    
    let e7 = document.getElementsByClassName("learn")[0]
    if (e7) e7.style.display = 'none';
    
    let e8 = document.getElementsByClassName("page-footer")[0]
    if (e8) e8.style.display = 'none';
    
    let ads = document.getElementsByClassName("adslot")
    for (var i = 0; i < ads.length; i++) {
        ads[i].style.display = "none";
    }

    var input = document.querySelector('#search')
    const enterKey = new KeyboardEvent("keydown", {
        bubbles: true, cancelable: true, keyCode: 13
    });
    123;
    """;

const FreeDictionaryJS =
    """
    document.querySelector("#header").style.display = "none";
    document.querySelectorAll(".adsbygoogle").forEach(function(node) {node.style.display = "none"})
    content = document.querySelector("#content")
    if (content) {
      let cName = content.className
      document.querySelectorAll(`.\${cName}`).forEach(function(node) {node.style.display = "none"})
      content.style.display = "block"
      document.querySelector("#content > div > aside").style.display = "none"
    }
    document.querySelector("#footer").style.display = "none"
    123;
    """;


String googleDictionaryJSSearchFor(String word) {
    return
      """
      searchBar.click()
      if (input == null) {
          input = document.querySelector('#sb_ifc50 > input')
      }

      input.value = "$word"
      input.dispatchEvent(new KeyboardEvent("keydown", {
          bubbles: true, cancelable: true, keyCode: 13
      }));
      123;
      """;
}

String vocabularyJSSearchFor(String word) {
    return
      """
      input.value = "$word"
      input.dispatchEvent(enterKey)
      
      jQuery(document).ajaxStop(function() {
        let e1 = document.getElementById('dictionary-upper-ad')
        if (e1) e1.style.display = 'none';

        let e2 = document.getElementsByClassName('leaderboard-ad')[0]
        if (e2) e2.style.display = 'none';

        let e3 = document.getElementById('google_ads_iframe_/15665503/Dictionary-Result-Right_0')
        if (e3) e3.outerHTML = ""

        let e4 = document.getElementsByClassName("section related nocontent robots-nocontent screen-only")[0]
        if (e4) e4.style.display = 'none';

        let e5 = document.getElementsByClassName("wordPage")[0]
        if (e5) {
          e5.style.paddingTop = '0px';
          e5.style.paddingBottom = '0px';
        }
          
        let e6 = document.getElementsByClassName("definitionsContainer")[0]
        if (e6) e6.firstElementChild.style.width = '100%';

        let e7 = document.getElementsByClassName("learn")[0]
        if (e7) e7.style.display = 'none';
      
        var ads = document.getElementsByClassName("adslot")
        for (var i = 0; i < ads.length; i++) {
          ads[i].style.display = "none";
        }
      
        function onClicked(word) {
          $VocabularyJSChannelName.postMessage(word);
        }
      
        function monitorLinks() {
          var elements = Array.from(document.getElementsByTagName("a")).filter(element => element.className == 'word');
          for(var i = 0; i < elements.length; i++){
            elements[i].onclick = (function(opt) {
              return function() {
                onClicked(String(opt.innerText));
              };
            })(elements[i]);
          }
        }
      
        monitorLinks()
      })
      123;
      """;
}

String freeDictionaryJSSearchFor(String word) {
    return
        """
          input = document.querySelector("#f1Word")
          input.value = "$word"
          input.parentElement.lastElementChild.click()
          123;
        """;
}
