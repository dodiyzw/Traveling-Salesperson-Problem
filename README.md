# Traveling-Salesperson-Problem

This project is interested in finding out, given that a student from Yale-NUS wants to visit attractions in Singapore, what is the path that would take the shortest time to visit all attractions and return to Yale-NUS. The definition of attractions for this project is constrained to the popular and mainstream destinations, such as Gardens by the Bay, Orchard Road, Jewel and etc. As such, the attractions list in this project is by no means exhaustive. This project will make use of network theory to find the shortest path to visit all these attractions from Yale-NUS and then return to Yale-NUS. Specifically, a person traveling on this path will only visit each tourist attraction once, and then return to the starting location, which is Yale-NUS. This setup is a canonical problem in operations research known as Traveling Salesperson Problem (TSP). This project utilizes the City Mappers API to retrieve the transit time data. 

---
### Approach 

Because the number of nodes in this project is small ( n = 7), this project uses the Naive Brute Force solution where we find the permutation of every path and calculate its cost. The path with minimum cost is then extracted from the array. A user-defined structure is used to save the cost and corresponding path as an object that is callable. All code is written in Julia. 

---
### Assumptions and limitations

Firstly, as the API only returns the best transit time, it does not distinguish between MRT travel or bus travel, or possibly a combination of both. However, the transit time includes waiting time for the transport mode. Additionally, because API sends real-time requests to the server, it returns the transit time at the point of data collection. This is an important limitation as transit time would vary based on time of the day and day of the week. The model does not factor for how much time a person would stay at each location, and hence one would definitely spend more than 253 minutes to travel to all these locations and tour around the destinations. It is also important to note that the solution proposed in this project is based on a brute force approach and is not the most optimal solution. An optimal solution would model the problem as an integer programming problem, which can be an extension of the current work. 
