using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MovieShopMVC.Models;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Infrastructure.Services;

namespace MovieShopMVC.Controllers
{
    public class HomeController : Controller
    {
        private MovieService _movieService;

        public HomeController()
        {
            _movieService = new MovieService();
        }

        public IActionResult Index()

        {
            var movies = _movieService.GetTopRevenueMovies();
            // 3 ways to pass data from controller to view
            // 1 Strongly Typed Models ******
            // 2 ViewBag
            // 3 ViewData
            // get top revenue movie and display on the view
            // localhost:5001/movies/details/2

            ViewBag.PageTitle = "Top Revenue Movie";
            ViewData["TotalMovies"] = movies.Count();

            return View(movies);
        }



        // Clean Architecture

        // Interfaces

        // IMovieService

        // class MovieService : SOmeClass, GenreService
        // {
        // }


        // class MovieService2 : IMovieSerivce
        // {
        // }

        // Depedency Injection
        // Application core layer
        // Entities => C# classes that repewsents your domian/database objjects =>
        // Models => 

        // 15 tables
        // 20 columns , Movie Table
        // Entity => Movie 20 properties

        // Models => UI
        // Movie list => MovieCardModel => id, title, posterimage
        // DTO (Data Transfer Objetcs) => API

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
