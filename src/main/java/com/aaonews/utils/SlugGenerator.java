package com.aaonews.utils;

import java.text.Normalizer;
import java.util.Locale;
import java.util.regex.Pattern;

/**
 * Utility class for generating URL-friendly slugs from text
 */
public class SlugGenerator {

    private static final Pattern NONLATIN = Pattern.compile("[^\\w-]");
    private static final Pattern WHITESPACE = Pattern.compile("[\\s]");
    private static final Pattern MULTIPLE_DASHES = Pattern.compile("-+");

    /**
     * Generates a URL-friendly slug from the given text
     *
     * @param input The text to convert to a slug
     * @return A URL-friendly slug
     */
    public static String generateSlug(String input) {
        if (input == null) {
            return "";
        }

        // Convert to lowercase
        String result = input.toLowerCase(Locale.ENGLISH);

        // Remove accents
        result = Normalizer.normalize(result, Normalizer.Form.NFD);

        // Remove non-Latin characters
        result = NONLATIN.matcher(result).replaceAll("");

        // Replace whitespace with dashes
        result = WHITESPACE.matcher(result).replaceAll("-");

        // Replace multiple dashes with a single dash
        result = MULTIPLE_DASHES.matcher(result).replaceAll("-");

        // Remove leading and trailing dashes
        result = result.replaceAll("^-", "").replaceAll("-$", "");

        return result;
    }
}