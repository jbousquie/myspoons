class MyChart {
    constructor(ctx, dataString) {
        this.ctx = ctx;
        this.dataArray = this.computeArrayFromString(dataString);
        this.labels = [];
        this.data = [];
    }

    // Removes diacritics
    strNoAccent(a) {
        var d = a.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
        return d;
    }

    // cleans up the string characters (no upper-cases, no accents, etc)
    cleanDataString(dataString) {
        let tmp = dataString.toLowerCase();
        return this.strNoAccent(tmp);
    }

    // Transforms the raw string data into an array of arrays
    fromStringToArray(dataString) {
        let cleanedString = this.cleanDataString(dataString);
        let linesArray = cleanedString.split('\n');
        linesArray.shift();  // the first line is the header
        linesArray.pop();    // the last line is always empty
        let dataArray = linesArray.map(line => line.split(';'));
        return dataArray;
    }

    // Computes and adds the deltas of energy rates between 2 successive rows in the array
    addDeltas(dataArray) {
        let l = dataArray.length;
        dataArray[0].push(0);  // initial energy delta
        for (let i = 1; i < l; i++) {
            let previousRow = dataArray[i - 1];
            let row = dataArray[i];
            let nrgStart = parseInt(previousRow[2]);
            let nrgEnd = parseInt(row[2]);
            let delta = nrgEnd - nrgStart;
            row.push(delta);
        }
    }

    computeCommentInstances(dataArray) {

    }

    // does all the computation to get a clean data array from a raw data string
    computeArrayFromString(dataString) {
        let dataArray = this.fromStringToArray(dataString);
        this.addDeltas(dataArray);
        console.log(dataArray);
        return dataArray;
    }


    display(chartType) {
        chartType = chartType ? chartType : 1;
        switch (chartType) {
            case 1:
                this.displayBars();
                break;
            case 2:
                //
                break;

        }
    }

    // Faire des graphes par jour de la semaine, par semaine, par mois
    // calculer les deltas
    // calculer  les occurences de commentaires

    getDataForBars() {
        let labels = this.labels;
        let data = this.data;
        let arr  = this.dataArray;
        arr.forEach(row => {
            let date = row[0];
            let rate = row[2];
            let comment = row[5];
            let label = [comment];
            labels.push(label);
            data.push(rate);
        });
    }

    displayBars() {
        this.getDataForBars();
        new Chart(
            this.ctx,
            {
                type: 'bar',
                data: {
                    labels: this.labels,
                    datasets: [ {
                        label: 'Energy by event',
                        data: this.data
                    } ]
                }
            }
        ) 
    }
}