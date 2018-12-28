#This is a test file. 
print('Hello World!')
testScores <- read.csv("C:/Users/logan/Downloads/StudentsPerformance.csv")
t.test(math.score ~ gender, data = testScores, var.equal = TRUE)