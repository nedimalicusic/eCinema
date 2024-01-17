using AutoMapper;
using eCinema.Application;
using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Core.Dtos.Movie;
using eCinema.Core.Dtos.Photo;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Api.Controllers
{
    public class MovieController : BaseCrudController<MovieDto, MovieUpsertDto, MovieSearchObject, IMoviesService>
    {
        private readonly IPhotosService _photosService;
        private readonly IMapper _mapper;
        public MovieController(IMapper mapper, IPhotosService photosService, IMoviesService service, ILogger<MovieController> logger) : base(service, logger)
        {
            _mapper = mapper;
            _photosService = photosService;
        }

        [HttpGet("GetLastAddMovies")]
        public async Task<IActionResult> GetLastAddMovies(int size,CancellationToken cancellationToken = default)
        {
            try
            {

                var movies = await Service.GetLastAddMovies(size,cancellationToken);
                return Ok(movies);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to get movies");
                return BadRequest();
            }
        }

        [HttpGet("GetMostWatchedMovies")]
        public async Task<IActionResult> GetMostWatchedMovies(int size,CancellationToken cancellationToken = default)
        {
            try
            {

                var movies = await Service.GetMostWatchedMovies(size,cancellationToken);
                return Ok(movies);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to get movies");
                return BadRequest();
            }
        }


        [HttpPost("insertMovie")]
        public async Task<IActionResult> InsertMovie([FromForm] MovieUpsertModel model, CancellationToken cancellationToken = default)
        {
            try
            {
                var upsertDto = _mapper.Map<MovieUpsertDto>(model);

                if (model.Photo != null && model.Photo.Length > 0)
                {
                    var formFile = model.Photo;
                    using (var memoryStream = new MemoryStream())
                    {
                        await formFile.CopyToAsync(memoryStream);
                        var photoData = memoryStream.ToArray();

                        var photoInputModel = new PhotoUpsertModel
                        {
                            FileName = formFile.FileName,
                            Type = formFile.ContentType,
                            Content = formFile.OpenReadStream()
                        };

                        var guidId = await _photosService.ProcessAsync(new List<PhotoUpsertModel> { photoInputModel });

                        var photoId = await _photosService.GetPhotoIdByGuidId(guidId[0], cancellationToken);

                        upsertDto.PhotoId = photoId;
                    }
                }

                var movie = await Service.AddAsync(upsertDto, cancellationToken);

                return Ok(movie);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to add a movie");
                return BadRequest();
            }
        }

        [HttpPut("updateMovie")]
        public async Task<IActionResult> Put([FromForm] MovieUpsertModel model, CancellationToken cancellationToken = default)
        {
            try
            {
                var upsertDto = _mapper.Map<MovieUpsertDto>(model);

                if (model.Photo != null && model.Photo.Length > 0)
                {
                    var formFile = model.Photo;
                    using (var memoryStream = new MemoryStream())
                    {
                        await formFile.CopyToAsync(memoryStream);
                        var photoData = memoryStream.ToArray();

                        var photoInputModel = new PhotoUpsertModel
                        {
                            FileName = formFile.FileName,
                            Type = formFile.ContentType,
                            Content = formFile.OpenReadStream()
                        };

                        var guidId = await _photosService.ProcessAsync(new List<PhotoUpsertModel> { photoInputModel });

                        var photoId = await _photosService.GetPhotoIdByGuidId(guidId[0], cancellationToken);

                        upsertDto.PhotoId = photoId;
                    }
                }
                else
                {

                    var movie = await Service.GetByIdAsync(model.Id, cancellationToken);
                    upsertDto.PhotoId = (int)movie!.PhotoId;
                }

                await Service.UpdateAsync(upsertDto, cancellationToken);

                return Ok(upsertDto);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to update movie");
                return BadRequest();
            }
        }

    }
}
