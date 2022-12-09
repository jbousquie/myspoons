class MyChart {
    
    constructor(ctx, maxSpoonNb, dataString) {
        Chart.register(ChartDataLabels);
        this.ctx = ctx;
        this.dataArray = this.computeArrayFromString(dataString);
        this.labels = [];
        this.customLabels = [];
        this.data = [];
        this.backgroundColor = [];
        this.maxSpoonNb = maxSpoonNb;
        this.wordMinLength = 4;
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

    // Returns an array of words longer than the min length, from a comment line
    getWordsFromComments(comment) {
        let comments = comment.split(' ');
        let minL = this.wordMinLength;
        let words = comments.filter(word => word.length >= minL);
        return words;
    }


    // From the passed dataArray, returns a sorted (by delta values) array of {delta: int, labels: [wordsFromCommentLongerThanMin]} 
    sortDeltasWithLabels(dataArray) {
        let deltas = dataArray.map(row => {
            let delta = row[6];
            let labels = this.getWordsFromComments(row[5]);
            return {delta: delta, labels: labels};
        });
        deltas.sort((a, b) => a.delta - b.delta);
        return deltas;
    }

    // Returns a sorted array (by count/velue desc) of {label: string, value: int, avg: float}
    sortLabelsByFrequency(dataArray) {
        let frequencies = {};
        let deltas = this.sortDeltasWithLabels(dataArray);
        deltas.forEach(row => {
            let labels = row.labels;
            let delta = row.delta;
            labels.forEach(label => {
                if (!(label in frequencies)) {
                    frequencies[label] = {value: 0, avg: 0, label: label};
                }
                let frq = frequencies[label];
                frq.value += 1;
                frq.avg += delta;
            });
        });
        let sortedFrequencies = [];
        for (let f in frequencies) {
            let frq = frequencies[f];
            frq.avg = frq.avg / frq.value;
            sortedFrequencies.push(frq);
        }
        sortedFrequencies.sort((a, b) => b.value - a.value);
        return sortedFrequencies;
    }

    // Returns an array of colors from the values in the valueArray
    getBarBackgroundColors(valueArray) {
        if (valueArray) {
            let colors = valueArray.map((element) => {             
                let val = element.value;
                let g = parseInt(155 + val);
                let clstr = 'rgba(0, ' + g + ', 100, 0.5)';
                return clstr;
            });
            console.log(colors)
            return colors;
        } else {
            return Chart.defaults.backgroundColor;
        }
    }


    // Does all the computation to get a clean data array from a raw data string
    // clean the strings and compute the deltas
    computeArrayFromString(dataString) {
        let dataArray = this.fromStringToArray(dataString);
        this.addDeltas(dataArray);
        return dataArray;
    }


    display(chartType) {
        chartType = chartType ? chartType : 1;
        switch (chartType) {
            case 1:
                this.displayFrequencies();
                break;
            case 2:
                this.displayPie(10);
                break;

        }
    }

    getDataForFrequencies() {
        let labels = this.labels;
        let customLabels = this.customLabels;
        let data = this.data;
        let arr  = this.sortLabelsByFrequency(this.dataArray);
        this.backgroundColor = this.getBarBackgroundColors(arr);
        let maxSpoonNb = this.maxSpoonNb;
        arr.forEach(element => {
            // format the custom label
            let avg = element.avg * maxSpoonNb * 0.01;
            let sep = avg < 0 ? ' (' : ' (+';
            let fixAvg = (avg).toFixed(1);
            let customLabel = element.label  + sep + fixAvg + ')';
            customLabels.push(customLabel);
            labels.push(element.label);
            let sign = 1;
            if (element.avg < 0) {
                sign = -1;
            }
            data.push(sign * element.value);
        });
    }

    displayFrequencies() {
        this.getDataForFrequencies();
        new Chart(
            this.ctx,
            {
                type: 'bar',
                data: {
                    labels: this.labels,
                    customLabels: this.customLabels,  // own custom property
                    datasets: [ {
                        data: this.data,
                        backgroundColor: this.backgroundColor,
                    } ],
                },
                options: {
                    indexAxis: 'y', 
                    plugins:{ 
                        datalabels: {
                            formatter: function(value, context) {
                                return context.chart.data.customLabels[context.dataIndex]; // returns the chart label instead of the data value
                            },
                            anchor: 'center',
                            font: {size: "32"}
                        }
                    },
                }
            }
        ); 
    }

    getDataForPie(maxElements) {
        let labels = this.labels;
        let data = this.data;
        let arr = this.sortDeltasWithLabels(this.dataArray).slice(0, maxElements);
        arr.forEach(row => {
            labels.push(row['labels']);
            data.push(row['delta']);
        });
    }

    displayPie(maxElements) {
        this.getDataForPie(maxElements);
        new Chart(
            this.ctx,
            {
                type: 'pie',
                data: {
                    labels: this.labels,
                    datasets: [{
                        data: this.data
                    }],                    
                    hoverOffset: 4 
                }

            }
        );

    }
}