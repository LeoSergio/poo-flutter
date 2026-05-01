// Objeto para armazenar ano: url
//Cole no console
let urls = {};

// Percorre todos os links que contenham "resource"
document.querySelectorAll("a[href*='resource']").forEach((link) => {
    const texto = link.textContent + ' ' + link.href;

    // Tenta extrair o ano (2009–2024)
    const match = texto.match(/20\d{2}/);
    if (match) {
        const ano = parseInt(match[0]);
        if (ano >= 2009 && ano <= 2025) {  // 
            urls[ano] = link.href;
        }
    }
});

// Ordena por ano decrescente
const ordenado = Object.keys(urls)
    .sort((a, b) => b - a)
    .reduce((obj, key) => {
        obj[key] = urls[key];
        return obj;
    }, {});

// Mostra resultado final
console.log("📌 Dicionário final (2009–2024):");
console.log("urls =", JSON.stringify(ordenado, null, 4));
