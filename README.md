# PEC 4: Predicció de dolències cardíaques a partir d’un electrocardiograma
## Vicent Caselles Ballester

Aquest repositori/directori conté la meva *submission* per a la PEC4 de l'assignatura de *Machine Learning*. Per a executar l'anàlisi del fitxer `.csv`, simplement cal que executeu la següent comanda:

```bash
Rscript main.R
```

Això correrà un *script* principalment, però aquest en correrà d'altres, i.e. els fitxers `.R` i el *jupyter notebook* amb nom `PEC4-Python.ipynb`. Així doncs, necessites tenir una instal·lació de `python`, `jupyter`, i els paquets de `python` que trobaràs a `requirements.txt`. També instal·leu els paquets de `R` que trobareu a `requirements.R`. Caldrà doncs tenir `R`, `Markdown`, i un processador de `latex` per a generar els fitxers `.pdf`.

Sobre el fitxer `.ipynb`, preparar-lo per a que pugui córrer a qualsevol ordinador no és un tema trivial. El problema es troba a la metadata de la *notebook*, que requereix que especifiquis el nom del `kernel` de `ipython` que correrà la *notebook*. Adjuntaré els resultats obtinguts amb les xarxes neuronals a l'entrega de la PEC, per a saltar-me aquest problema (el codi detecta els resultats i no corre la *notebook*). Si voleu córrer el fitxer `.ipynb`, heu d'obrir-la i canviar, a la metadata, els següents camps: `name`, `display_name`; allà heu de treure el nom que hi ha (que és el que correspon al meu `venv`), i ficar el nom del `kernel` o `venv` on tingueu instal·lat els *requirements* per a córrer les xarxes neuronals (i.e. `keras`, `numpy`, etc.; ho trobareu a `requirements.txt`).

Es generaran els següents *outputs*:

* Un fitxer `.pdf` i un fitxer `.html` d'acord amb el fitxer `PEC4-R.Rmd`.
* Un fitxer `.pdf` resultat de córrer el *Jupyter Notebook* (`.ipynb`). Aquest realment no cal que s'inspeccioni, ja que s'analitza al fitxer `PEC4-R.Rmd` (i per tant al `pdf` amb el mateix nom), utilitzant-les per a valorar-ne la *performance*. Tot i això, recomano que s'obri per a entendre el codi `Python`.
* Un fitxer `.csv` amb les mètriques per classe de tots els algorismes. Aquests resultats no es mostren explícitament a l'informe, però si que es comenten. Obriu-lo si voleu comprovar les afirmacions que faig allà.

## Run dockerized

You can run this code in a docker container. To do that (first install docker, obv), run the following command:

```bash
./run_dockerized.sh
```

If you wanna change the input file, please change the `DOCKERFILE` accordingly (and the `main.R params` also). Sorry if that's not convenient. I'm still learning.

### Canvis en els fitxers d'entrada

Podeu canviar els paràmetres (com el fitxer `.csv` que s'analitzarà, la classe a predir...) modificant el fitxer `main.R`. Mireu els paràmetres que s'expliciten allà per a entendre que necessiteu especificar.

### Separació *train test*

Es duu a terme amb una partició $67\% - 33\%$. Ho duu a terme el fitxer `R_code/split_dataset.R`. Si voleu veure com ho faig, obriu aquest fitxer.

### Assumpcions que fa aquest *projecte*

* Tenim rownames a la primera columna dels fitxers `.csv`.