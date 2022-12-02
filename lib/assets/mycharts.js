class MyChart {
    constructor(ctx, dataString) {
        this.ctx = ctx;
        this.dataArray = this.fromStringToArray(dataString); // an array of arrays (one per row)
        this.labels = [];
        this.data = [];
    }

    fromStringToArray(dataString) {
        let linesArray = dataString.split('\n');
        linesArray.shift();  // the first line is the header
        linesArray.pop();    // the last line is always empty
        let dataArray = linesArray.map(line => line.split(';'));
        return dataArray;
    }

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