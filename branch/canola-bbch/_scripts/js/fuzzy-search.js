// Enhanced fuzzy search configuration for Quarto
// Overrides the default Fuse.js threshold to enable better fuzzy matching

(function() {
  const originalAddEventListener = EventTarget.prototype.addEventListener;
  
  EventTarget.prototype.addEventListener = function(type, listener, options) {
    if (type === 'DOMContentLoaded' && this === window.document) {
      const wrappedListener = function(event) {
        // Override Fuse initialization before Quarto uses it
        if (window.Fuse && typeof window.Fuse === 'function') {
          const OriginalFuse = window.Fuse;
          
          window.Fuse = function(list, options) {
            // Enhance options for word-by-word matching
            const enhancedOptions = options ? {...options} : {};
            
            // Configure for better word-by-word matching:
            // - Lower threshold (0.3) for more precise matches
            // - ignoreLocation: search entire text, not just beginning
            // - useExtendedSearch: enables token-based searching
            // - minMatchCharLength: minimum 2 characters per match
            enhancedOptions.threshold = 0.3;
            enhancedOptions.distance = 1000;
            enhancedOptions.ignoreLocation = true;
            enhancedOptions.useExtendedSearch = true;
            enhancedOptions.minMatchCharLength = 2;
            
            return new OriginalFuse(list, enhancedOptions);
          };
          
          // Copy static properties if any
          for (let prop in OriginalFuse) {
            if (OriginalFuse.hasOwnProperty(prop)) {
              window.Fuse[prop] = OriginalFuse[prop];
            }
          }
        }
        
        return listener.apply(this, arguments);
      };
      
      return originalAddEventListener.call(this, type, wrappedListener, options);
    }
    
    return originalAddEventListener.call(this, type, listener, options);
  };
})();
