package org.mbds;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

public class Anagram {

  
    public static class AnagramMapper extends Mapper<Object, Text, Text, Text> {

        private Text sortedWord = new Text();
        private Text originalWord = new Text();

        @Override
        protected void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            String word = value.toString().toLowerCase().replaceAll("[^a-z]", "");

            if (!word.isEmpty()) {
                char[] letters = word.toCharArray();
                Arrays.sort(letters);
                sortedWord.set(new String(letters));
                originalWord.set(word);
                context.write(sortedWord, originalWord);
            }
        }
    }


    public static class AnagramReducer extends Reducer<Text, Text, Text, Text> {

        @Override
        protected void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
            ArrayList<String> anagrams = new ArrayList<>();

            for (Text value : values) {
                anagrams.add(value.toString());
            }

            if (anagrams.size() > 1) {
                context.write(key, new Text(String.join(", ", anagrams)));
            }
        }
    }

    public static void main(String[] args) throws IOException, InterruptedException, ClassNotFoundException {
        Configuration conf = new Configuration();

        String[] ourArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
        if (ourArgs.length != 2) {
            System.err.println("Usage: anagram <in> <out>");
            System.exit(2);
        }

        Job job = Job.getInstance(conf, "Anagram");
        job.setJarByClass(Anagram.class);
        job.setMapperClass(AnagramMapper.class);
        job.setReducerClass(AnagramReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        // Indicate from where to read input data from HDFS.
        FileInputFormat.addInputPath(job, new Path(ourArgs[0]));
        // Indicate where to write the results on HDFS.
        FileOutputFormat.setOutputPath(job, new Path(ourArgs[1]));

        // We start the MapReduce Job execution (synchronous approach).
        // If it completes with success we exit with code 0, else with code 1.
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
