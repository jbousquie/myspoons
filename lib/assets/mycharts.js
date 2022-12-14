class MyChart {

    static MIXED = 1;
    static BY_FREQUENCY = 2;
    static BY_INTENSITY = 3;
    static AVG_BY_PERIOD = 4;
    static COUNT_BY_PERIOD = 5;
    static PERIOD_WEEKDAY = 20;
    static PERIOD_HOUR = 21;
    
    constructor(ctx, maxSpoonNb, dataString) {
        Chart.register(ChartDataLabels);
        this.ctx = ctx;
        this.dataArray = this.computeArrayFromString(dataString);
        this.labels = [];
        this.customLabels = [];
        this.data = [];
        this.data2 = [];
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
    addDeltas(dataArray) {dataArray
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
            let weekDay = row[1];
            let labels = this.getWordsFromComments(row[5]);
            return {delta: delta, labels: labels};
        });
        deltas.sort((a, b) => a.delta - b.delta);
        return deltas;
    }

    // Returns a sorted array of {label: string, count: int, avg: float} by measurementType : frequency, intensity, or mix
    sortLabelsByMeasurement(dataArray, measurementType) {
        let measurements = {};
        let deltas = this.sortDeltasWithLabels(dataArray);
        deltas.forEach(row => {
            let labels = row.labels;
            let delta = row.delta;
            labels.forEach(label => {
                if (!(label in measurements)) {
                    measurements[label] = {count: 0, avg: 0, label: label};
                }
                let msr = measurements[label];
                msr.count += 1;
                msr.avg += delta;
            });
        });
        let sortedMeasurements = [];
        for (let f in measurements) {
            let msr = measurements[f];
            msr.avg = msr.avg / msr.count;
            sortedMeasurements.push(msr);
        }
        switch (measurementType) {
            case (MyChart.MIXED):
                sortedMeasurements.sort((a,b) => Math.abs(b.avg * b.count) - Math.abs(a.avg * a.count));
                break;
            case (MyChart.BY_INTENSITY): {
                sortedMeasurements.sort((a, b) => Math.abs(b.avg) - Math.abs(a.avg));
                break;
            }
            case (MyChart.BY_FREQUENCY): {
                sortedMeasurements.sort((a, b) => b.count - a.count);
                break;
            }
        }
        return sortedMeasurements;
    }

    // Returns an array of 2 arrays [minus, plus]
    // minus about negative deltas, plus about positive ones
    // containing each 7 objets max {count: int, delta: int, avg: int }, one per day of the week
    getDataByWeekDay() {
        let minus = [];
        let plus = [];
        let weekDays = [minus, plus];
        let dataArray = this.dataArray;
        //this.labels = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        for (let i = 0; i <= 7; i++) {
            minus[i] = {count: 0, delta: 0, avg: 0};
            plus[i]  = {count: 0, delta: 0, avg: 0};
        }
        dataArray.forEach(row => {
            let dayN = parseInt(row[1]);
            let delta = row[6];
            let minusDay = minus[dayN];
            let plusDay = plus[dayN];
            if (delta < 0) {
                minusDay.count += 1;
                minusDay.delta += delta;
            }
            else {
                plusDay.count += 1;
                plusDay.delta += delta;
            }
        });
        for (let i = 0; i < 8; i++) {
            minus[i].avg = minus[i].count > 0 ?  minus[i].delta / minus[i].count : 0;
            plus[i].avg = plus[i].count > 0 ?  plus[i].delta / plus[i].count : 0;
        }
        minus.shift();
        plus.shift();
        return weekDays;
    }


    getDataByHour() {
        let minus = [];
        let plus = [];
        let hours = [minus, plus];
        let dataArray = this.dataArray;
        let minIndex = 24;
        let maxIndex = 0;
        dataArray.forEach(row => {
            let dateStr = row[0];
            let delta = row[6];
            let rowDate = new Date(dateStr);
            let hour = rowDate.getHours();
            minIndex = hour < minIndex ? hour : minIndex;
            maxIndex = hour > maxIndex ? hour : maxIndex;
            if (!minus[hour]) {
                minus[hour] = {count: 0, delta: 0, avg: 0};
            }
            if (!plus[hour]) {
                plus[hour] = {count: 0, delta: 0, avg: 0};
            }
            if (delta < 0) {
                minus[hour].count += 1;
                minus[hour].delta += delta;
            }
            else {
                plus[hour].count += 1;
                plus[hour].delta += delta;
            }
        })
        for (let i = minIndex; i <= maxIndex; i++) {
            let minusH = minus[i];
            let plusH = plus[i];
            if (minusH) {
                minusH.avg = minusH.count > 0 ? minusH.delta / minusH.count : 0;
            }
            else {
                minus[i] = {count: 0, delta: 0, avg: 0};
            }
            if (plusH) {
                plusH.avg = plusH.count > 0 ? plusH.delta / plusH.count : 0;
            }
            else {
                plus[i] = {count: 0, delta: 0, avg: 0};
            }
            let label = `${i} h - ${i+1} h`;
            this.labels.push(label);                   
        }
        return hours;
    }
    // returns the maximum absolute value from an array
    getMaxAbsoluteValue(arr) {
        let max = arr.reduce(function(a, b) {
            return Math.max(Math.abs(a), Math.abs(b));
        })
        return max;
    }

    // Returns an array of colors from the values in the valueArray
    getBarBackgroundColors(valueArray) {
        if (valueArray) {
            let values = valueArray.map((element) => element.count);
            let max = this.getMaxAbsoluteValue(values);
            let step = (max > 0) ? 200 / max : 1;

            let colors = valueArray.map((element) => {             
                let val = element.count * step;
                let avg = element.avg;
                let c = 0;
                let clstr = ('rgba(');
                if (avg >= 0) {
                    c = parseInt(55 + val);
                    clstr = clstr + '0, ' + c + ', 100, 0.4)';
                }
                else {
                    c = parseInt(55 + val);
                    clstr = clstr + c + ', 50, 10, 0.4)';
                }
                return clstr;
            });
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

    // Sets the datasets and the labels for the bar rendering
    getDataForMeasurement(type) {
        let labels = this.labels;
        let customLabels = this.customLabels;
        let data = this.data;
        let arr  = this.sortLabelsByMeasurement(this.dataArray, type);
        this.backgroundColor = this.getBarBackgroundColors(arr);
        let maxSpoonNb = this.maxSpoonNb;
        arr.forEach(element => {
            // format the custom label

            let dat = 0;
            let customLabel = '';
            let avg = element.avg * maxSpoonNb * 0.01;;
            let sep = avg < 0 ? ' (' : ' (+';
            switch(type) {
                case (MyChart.MIXED):
                    dat = element.count * element.avg;
                    let fixIntensity = (dat).toFixed(1);
                    customLabel = element.label + sep + fixIntensity + ')';
                    break;
                case (MyChart.BY_FREQUENCY):
                    let fixAvg = (avg).toFixed(1);
                    customLabel = element.label  + sep + fixAvg + ')';
                    let sign = (element.avg < 0) ? -1 : 1;
                    dat = sign * element.count;
                    break;
                case (MyChart.BY_INTENSITY):
                    customLabel = element.label + ' (' + element.count + ')';
                    dat = element.avg;
                    break;
            }
            labels.push(element.label);
            customLabels.push(customLabel);
            data.push(dat);
        });
    }



    getDataForPeriod(period, type) {
        let periodData;
        switch (period) {
            case MyChart.PERIOD_WEEKDAY:
                periodData = this.getDataByWeekDay();
                break;
            case MyChart.PERIOD_HOUR:
                periodData = this.getDataByHour();
                break;
        }  
        let losses = periodData[0].filter(n => n);  // filter() to get rid off potential empty/undefined elements
        let gains = periodData[1].filter(n => n);
        for (let i = 0; i < losses.length; i++) {
            let loss = losses[i];
            let gain = gains[i];
            let dat1 = '';
            let dat2 = '';
            switch (type) {
                case MyChart.AVG_BY_PERIOD:
                    dat1 = loss.avg > 0 ? '+' + loss.avg.toFixed(1) : loss.avg.toFixed(1);   
                    dat2 = gain.avg > 0 ? '+' + gain.avg.toFixed(1) : gain.avg.toFixed(1);
                    dat1 = loss.avg == 0 ? '' : dat1;
                    dat2 = gain.avg == 0 ? '' : dat2;
                    break;
                case MyChart.COUNT_BY_PERIOD:
                    dat1 = loss.count == 0 ? '' : (-loss.count).toString();
                    dat2 = gain.count == 0 ? '' : gain.count.toString();
                    break;
            }
            dat1 = loss.avg == 0 ? '' : dat1;
            dat2 = gain.avg == 0 ? '' : dat2;
            this.data.push(dat1);
            this.data2.push(dat2);
        }
    }

    displayPyramidPeriod(period, type, horizontal) {
        this.getDataForPeriod(period, type);
        let indexAxis = horizontal ? 'y' : 'x';
        new Chart(
            this.ctx,
            {
                type: 'bar',
                data: {
                    labels: this.labels,
                    chartType: type,  // custom property
                    datasets: [ 
                        {
                            label: 'Loss',
                            data: this.data,
                            backgroundColor: 'rgba(255, 0, 0, 0.5)'
                        },
                        {
                            label: 'Gain',
                            data: this.data2,
                            backgroundColor: 'rgba(0, 255, 0, 0.5)'
                        }
                    ]
                },
                options: {
                    indexAxis: indexAxis,
                    responsive: true,
                    scales: {
                        x: {stacked: true},
                        y: {stacked: true}
                    },
                    plugins: {
                        datalabels: {
                            formatter: function(value, context) {
                                if (context.chart.data.chartType == MyChart.AVG_BY_DAY) {
                                    return value;
                                }
                                let lbl = value;
                                if (lbl[0] == '-') {
                                    lbl = lbl.substring(1);
                                }
                                return lbl;
                            },
                            font: {size: "32"}
                        }
                    }
                }
            }

        );

    }

    displayBarEvents(type) {
        this.getDataForMeasurement(type);
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
    display(chartType, labelString, title, description) {
        chartType = chartType ? chartType : 1;
        this.labels = labelString != '' ? JSON.parse(labelString) : this.labels;
        switch (chartType) {
            case 1:
                this.displayBarEvents(MyChart.MIXED);
                break;
            case 2:
                this.displayBarEvents(MyChart.BY_FREQUENCY);
                break;
            case 3:
                this.displayBarEvents(MyChart.BY_INTENSITY);
                break;
            case 4:
                this.displayPyramidPeriod(MyChart.PERIOD_WEEKDAY, MyChart.AVG_BY_PERIOD, true);
                break;
            case 5:
                this.displayPyramidPeriod(MyChart.PERIOD_WEEKDAY, MyChart.COUNT_BY_PERIOD, true);
                break;
            case 6:
                this.displayPyramidPeriod(MyChart.PERIOD_HOUR, MyChart.AVG_BY_PERIOD, false);
                break;
            case 7:
                this.displayPyramidPeriod(MyChart.PERIOD_HOUR, MyChart.COUNT_BY_PERIOD, false);
                break;
        }
        let title_elem = document.getElementById('title');
        title_elem.innerHTML = title;
        let desc_elem = document.getElementById('description');
        desc_elem.innerHTML = description;
    }
}