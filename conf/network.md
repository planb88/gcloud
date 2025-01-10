# Network addresses allocation

Top level network is 10.0.0.0/8

split it to 64 subnetworks with the size of /14

10.0.0.0/14 .. 10.252.0.0/14

Clients ranges

| Client ranges |
|---------------|
| 10.0.0.0/14   |
| 10.4.0.0/14   |
| 10.8.0.0/14   |
| 10.12.0.0/14  |
| 10.16.0.0/14  |
| ...           |
| 10.240.0.0/14 |
| 10.244.0.0/14 |
| 10.248.0.0/14 |
| 10.252.0.0/14 |

Each such range can have up to 16 environments
> 10.16.0.0/14

| Env Name | Subnet address | Hosts | Region       |
|---------|----------------|-------|--------------|
| [default](https://www.davidc.net/sites/default/subnets/subnets.html?network=10.16.0.0&mask=18&division=15.7911) | 10.16.0.0/18   | 16382 | europe-west4 |
| dev     | 10.16.64.0/18  | 16382 | europe-west4 |
| dev2    | 10.16.128.0/18 | 16382 |              |
| dev3    | 10.16.192.0/18 | 16382 |              |
| test    | 10.17.0.0/18   | 16382 |              |
| test2   | 10.17.64.0/18  | 16382 |              |
| test3   | 10.17.128.0/18 | 16382 |              |
| test4   | 10.17.192.0/18 | 16382 |              |
| stg     | 10.18.0.0/18   | 16382 |              |
| stg1    | 10.18.64.0/18  | 16382 | europe-west1 |
| stg2    | 10.18.128.0/18 | 16382 | europe-west2 |
| prod    | 10.18.192.0/18 | 16382 |              |
| reserved | 10.19.0.0/18   | 16382 |              |
| reserved | 10.19.64.0/18  | 16382 |              |
| reserved | 10.19.128.0/18 | 16382 |              |
| reserved | 10.19.192.0/18 | 16382 |              |
