package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
      io.flutter.plugins.firebaseauth.FirebaseAuthPlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.firebaseauth.FirebaseAuthPlugin"));
      io.flutter.plugins.firebase.core.FirebaseCorePlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.firebase.core.FirebaseCorePlugin"));
    flutterEngine.getPlugins().add(new com.dormmom.flutter_mapbox_navigation.FlutterMapboxNavigationPlugin());
    flutterEngine.getPlugins().add(new com.baseflow.geolocator.GeolocatorPlugin());
    flutterEngine.getPlugins().add(new com.baseflow.googleapiavailability.GoogleApiAvailabilityPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.googlesignin.GoogleSignInPlugin());
    flutterEngine.getPlugins().add(new com.baseflow.location_permissions.LocationPermissionsPlugin());
      com.mapbox.mapboxgl.MapboxMapsPlugin.registerWith(shimPluginRegistry.registrarFor("com.mapbox.mapboxgl.MapboxMapsPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.pathprovider.PathProviderPlugin());
    flutterEngine.getPlugins().add(new com.tekartik.sqflite.SqflitePlugin());
  }
}
