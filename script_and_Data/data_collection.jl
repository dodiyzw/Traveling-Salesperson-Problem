using HTTP, JSON, DataFrames
using CSV
using DataStructures


#provide a set of coordinate dictionary for HTTP request
coordinates = OrderedDict(
    "YNC" => "1.3071245199420003, 103.77167655144235",
    "Haw Par" => "1.2830384265858783, 103.78217299746967",
    "GBTB" => "1.2819276177110668, 103.86361319700919",
    "Orchard" => "1.3049813898567282, 103.83220912630519",
    "Chinatown" => "1.2847345218546116, 103.84356999746966",
    "Clarke Quay" => "1.2883322170514238, 103.84668776863414",
    "Jewel" => "1.3603852042025135, 103.9897914735741",
)

#function to query from City-mappers API. Refer to the documentation for more information. 
function get_data(starts, ends)
    url = "https://api.external.citymapper.com/api/1/traveltimes"
    headers = Dict(
        "Citymapper-Partner-Key" => "XyQKKDAV4RFYfxsLbhUU9iIbxxAlZgrt",
        "traveltime_types" => "transit",
        "start" => coordinates[starts],
        "end" => coordinates[ends],
    )
    r = HTTP.get(url, query = headers)
    # d = Dict(("$starts", "$ends") => JSON.parse(String(r.body))["transit_time_minutes"])
    return JSON.parse(String(r.body))["transit_time_minutes"]
end

starts = collect(keys(coordinates))
ends = collect(keys(coordinates))
data = [get_data(s, e) for s in starts, e in ends] #create a matrix of transit time

df = DataFrame(data, :auto) #convert to dataframe
rename!(df, starts) #renaming columns
insertcols!(df, 1, :name => collect(keys(coordinates))) # insert column label 
touch("data.csv") #create csv file to write to
CSV.write("data.csv", df) #write to csv file
