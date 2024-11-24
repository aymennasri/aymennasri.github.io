// Author: Aymen Nasri
// Version: <1.2.0>
// Description: Change plots theme depending on body class (quarto-light or quarto-dark)
// Originally made by Mickaël Canouil
// License: MIT

function updateImageSrc() {
  // Identifying which theme is on
  const isLightMode = document.body.classList.contains('quarto-light');
  const isDarkMode = document.body.classList.contains('quarto-dark');
  
  if (!isLightMode && !isDarkMode) return; // Exit if neither mode is active

  // Function to update styles
  const updateElements = (selector, updateFunc) => {
    document.querySelectorAll(selector).forEach(updateFunc);
  };

  // Function to replace the plots depending on theme
  updateElements('img', img => {
    const newSrc = img.src.replace(isLightMode ? '.dark' : '.light', isDarkMode ? '.dark' : '.light');
    if (newSrc !== img.src) img.src = newSrc;
  });

  // Update ggplot
  const updateStyle = (elem, prop, lightValue, darkValue) => {
    const currentValue = elem.style[prop];
    const newValue = isDarkMode ? darkValue : lightValue;
    if (currentValue !== newValue) elem.style[prop] = newValue;
  };

  // Update ploly background color for both the plot and the legend box
  updateElements('svg[style*="background"]', svg => updateStyle(svg, 'background', 'rgb(255, 241, 229)', 'rgb(34, 34, 34)'));
  updateElements('rect[style*="fill"]', rect => updateStyle(rect, 'fill', 'rgb(255, 241, 229)', 'rgb(34, 34, 34)'));

  // Save the original plotly styling + ggiraph legend text (cursor)
  updateElements('text[class*="legendtext"], svg text, svg tspan', text => {
    
    // Skip processing if the element is a Highcharts tooltip
    if (text.closest('.highcharts-tooltip')) return;
    
    if (!text.dataset.originalStyle) {
      const computedStyle = window.getComputedStyle(text);
      text.dataset.originalStyle = JSON.stringify({
        fill: computedStyle.fill,
        color: computedStyle.color,
        fontSize: computedStyle.fontSize,
        fontWeight: computedStyle.fontWeight,
        fontFamily: computedStyle.fontFamily,
        textDecoration: computedStyle.textDecoration
      });
    }
    
    // Handling the legend text that stays black\white even when hidden
    
    if (text.closest('.highcharts-legend-item')) {
      const legendItem = text.closest('.highcharts-legend-item');
      if (legendItem.classList.contains('highcharts-legend-item-hidden')) {
        // Lighter color for hidden items
        text.style.fill = isDarkMode ? 'rgba(255, 255, 255, 0.3)' : 'rgba(0, 0, 0, 0.3)';
      } else {
        // Normal color for visible items
        text.style.fill = isDarkMode ? 'white' : 'black';
      }
      return;
    }

    const originalStyle = JSON.parse(text.dataset.originalStyle);

    // Modify the text colors for plotly labels
    if (isDarkMode) {
      text.style.fill = 'white';
      text.style.color = 'white';
    } else {
      Object.assign(text.style, originalStyle);
    }
  });

  // Update table text color
  updateElements('.gt_table_body, .gt_heading, .gt_sourcenotes, .gt_footnotes', table => {
    if (isDarkMode) {
      table.style.color = 'white'; // Set text color to a light shade
    } else {
      table.style.color = ''; // Reset to default
    }
  });
  
  // Update ggiraph plot background color
  updateElements('.ggiraph-svg-bg', svg => {
    svg.style.fill = 'transparent';
    svg.style.stroke = 'transparent';
  });
  
  // Update ggiraph xG map background color
  updateElements('rect[stroke*="#696969"], rect[fill*="#FFFFFF"]', g => {
    g.style.fill = 'transparent';
  });
  
  updateElements('rect[fill*="#D9D9D9"]', g => {
    if (isDarkMode){
      g.style.fill = 'transparent';
      g.style.stroke = '#D9D9D9';
    } else {
      g.style.fill = '#D9D9D9';
    }
  });
};

// Observer making sure all changes are done
const observer = new MutationObserver(mutations => {
  if (mutations.some(mutation => 
      (mutation.type === 'attributes' && mutation.attributeName === 'class') ||
      (mutation.type === 'childList' && mutation.target.tagName === 'svg'))) {
    updateImageSrc();
  }
});

observer.observe(document.body, {
  attributes: true,
  childList: true,
  subtree: true,
  attributeFilter: ['class']
});

// Run on page load and immediately
document.addEventListener('DOMContentLoaded', updateImageSrc);
updateImageSrc();