CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
git clone $1 student-submission

cd student-submission

if [[ -f ListExamples.java ]]
then 
    echo "ListExamples Found"
else
    echo "Need file ListExamples.java"
    exit 1
fi

echo 'Finished cloning'

cd ../
cp student-submission/ListExamples.java ./

javac -cp ".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar" *.java > javac-errs.txt

if [[ $? -ne 0 ]] 
then
    echo "Compile error"
    exit $?
else
    echo "Compile Success"
fi

java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples > output.txt

grep ") test" output.txt > grep.txt

wc -l grep.txt > lines.txt

NUMBER=(`cat lines.txt` grep -o -E '[0-9]+') ;

grep "@Test" TestListExamples.java > NumTests.txt

TESTS=(`wc -l NumTests.txt`  grep -o -E '[0-9]+');

GRADE=$(($NUMBER - $TESTS))
GRADE=$(($GRADE * -1))

echo ""
echo "Grade: $GRADE / $TESTS"