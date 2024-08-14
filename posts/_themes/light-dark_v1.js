// Author: Aymen Nasri
// Version: <1.1.0>
// Description: Change image src depending on body class (quarto-light or quarto-dark)
// Originally made by Mickaël Canouil
// License: MIT

function updateImageSrc() {
  const bodyClass = document.body.classList;
  const images = document.querySelectorAll('img');
  const plotly = document.querySelectorAll('svg[style*="background"]');
  const legends = document.querySelectorAll('rect[style*="fill"]');
  const texts = document.querySelectorAll('text[class*="legendtext"]');

  images.forEach(image => {
    const src = image.src;
    let newSrc = src;
    if (bodyClass.contains('quarto-light') && src.includes('.dark')) {
      newSrc = src.replace('.dark', '.light');
    } else if (bodyClass.contains('quarto-dark') && src.includes('.light')) {
      newSrc = src.replace('.light', '.dark');
    }
    if (newSrc !== src) {
      image.src = newSrc;
    }
  });

  const updateStyles = (elements, property, lightValue, darkValue) => {
    elements.forEach(element => {
      const style = element.getAttribute('style');
      let newStyle = style;
      if (bodyClass.contains('quarto-light')) {
        if (style.includes(darkValue)) {
          newStyle = style.replace(darkValue, lightValue);
        }
      } else if (bodyClass.contains('quarto-dark')) {
        if (style.includes(lightValue)) {
          newStyle = style.replace(lightValue, darkValue);
        }
      }
      if (newStyle !== style) {
        element.setAttribute('style', newStyle);
      }
    });
  };

  updateStyles(plotly, 'background', 'rgb(255, 255, 255)', 'rgb(39, 43, 48)');
  updateStyles(legends, 'fill', 'rgb(255, 255, 255)', 'rgb(39, 43, 48)');
  updateStyles(texts, 'fill', 'rgb(68, 68, 68)', 'rgb(255, 255, 255)');
}

const observer = new MutationObserver(mutations => {
  mutations.forEach(mutation => {
    if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
      updateImageSrc();
    } else if (mutation.type === 'childList' && mutation.target.tagName === 'svg') {
      updateImageSrc();
    }
  });
});

observer.observe(document.body, {
  attributes: true,
  childList: true,
  subtree: true
});

updateImageSrc();

/*function updateImageSrc() {
  var bodyClass = window.document.body.classList;
  var images = window.document.getElementsByTagName('img');
  for (var i = 0; i < images.length; i++) {
    var image = images[i];
    var src = image.src;
    var newSrc = src;
    if (bodyClass.contains('quarto-light') && src.includes('.dark')) {
      newSrc = src.replace('.dark', '.light');
    } else if (bodyClass.contains('quarto-dark') && src.includes('.light')) {
      newSrc = src.replace('.light', '.dark');
    }
    if (newSrc !== src) {
      image.src = newSrc;
    }
  }
  var plotly = window.document.querySelectorAll('svg[style*="background"]');
  for (var i = 0; i < plotly.length; i++) {
    var plot = plotly[i];
    var style = plot.getAttribute('style');
    var newStyle = style;
    if (bodyClass.contains('quarto-light')) {
      if (style.includes('rgb(39, 43, 48)')) {
        newStyle = style.replace('rgb(39, 43, 48)', 'rgb(255, 255, 255)');
      }
    } else if (bodyClass.contains('quarto-dark')) {
      if (style.includes('rgb(255, 255, 255)')) {
        newStyle = style.replace('rgb(255, 255, 255)', 'rgb(39, 43, 48)');
      }
    }
    if (newStyle !== style) {
      plot.setAttribute('style', newStyle);
    }
  }
  var legends = window.document.querySelectorAll('rect[style*="fill"]');
  for (var i = 0; i < legends.length; i++) {
    var legend = legends[i];
    var lstyle = legend.getAttribute('style');
    var lnewStyle = lstyle;
    if (bodyClass.contains('quarto-light')) {
      if (lstyle.includes('rgb(39, 43, 48)')) {
        lnewStyle = lstyle.replace('rgb(39, 43, 48)', 'rgb(255, 255, 255)');
      }
    } else if (bodyClass.contains('quarto-dark')) {
      if (lstyle.includes('rgb(255, 255, 255)')) {
        lnewStyle = lstyle.replace('rgb(255, 255, 255)', 'rgb(39, 43, 48)');
      }
    }
    if (lnewStyle !== lstyle) {
      legend.setAttribute('style', lnewStyle);
    }
  }
  var texts = window.document.querySelectorAll('text[style*="fill"]');
  for (var i = 0; i < texts.length; i++) {
    var text = texts[i];
    var tstyle = text.getAttribute('style');
    var tnewStyle = tstyle;
    if (bodyClass.contains('quarto-light')) {
      if (tstyle.includes('rgb(255, 255, 255)')) {
        tnewStyle = tstyle.replace('rgb(255, 255, 255)', 'rgb(68, 68, 68)');
      }
    } else if (bodyClass.contains('quarto-dark')) {
      if (tstyle.includes('rgb(68, 68, 68)')) {
        tnewStyle = tstyle.replace('rgb(68, 68, 68)', 'rgb(255, 255, 255)');
      }
    }
    if (tnewStyle !== tstyle) {
      text.setAttribute('style', tnewStyle);
    }
  }
}

var observer = new MutationObserver(function(mutations) {
  mutations.forEach(function(mutation) {
    if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
      updateImageSrc();
    } else if (mutation.type === 'childList' && mutation.target.tagName === 'svg') {
      updateImageSrc();
    }
  });
});

observer.observe(window.document.body, {
  attributes: true,
  childList: true,
  subtree: true
});

updateImageSrc();*/