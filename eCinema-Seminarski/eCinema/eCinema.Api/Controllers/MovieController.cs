using AutoMapper;
using Microsoft.AspNetCore.Mvc;

using eCinema.Core;
using eCinema.Core.Dtos.Movie;
using eCinema.Core.Dtos.Photo;
using eCinema.Infrastructure;
using eCinema.Application.Interfaces;

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


        [HttpPost("insertMovie")]
        public async Task<IActionResult> InsertMovie([FromForm] MovieUpsertModel model, CancellationToken cancellationToken = default)
        {
            try
            {
                var genreIds = model.GenreIds.Split(',').Select(int.Parse).ToList();
                var actorsIds = model.ActorIds.Split(',').Select(int.Parse).ToList();
                var categoriesIds = model.CategoryIds.Split(',').Select(int.Parse).ToList();
                var upsertDto = _mapper.Map<MovieUpsertDto>(model);
                upsertDto.ActorIds = actorsIds.ToArray();
                upsertDto.CategoryIds = categoriesIds.ToArray();
                upsertDto.GenreIds = genreIds.ToArray();


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
                var genreIds = model.GenreIds != null ? model.GenreIds.Split(',').Select(int.Parse).ToList() : null;
                var actorsIds = model.ActorIds != null ? model.ActorIds.Split(',').Select(int.Parse).ToList() : null;
                var categoriesIds = model.CategoryIds != null ? model.CategoryIds.Split(',').Select(int.Parse).ToList() : null;
                var upsertDto = _mapper.Map<MovieUpsertDto>(model);
                upsertDto.ActorIds = actorsIds?.ToArray();
                upsertDto.CategoryIds = categoriesIds?.ToArray();
                upsertDto.GenreIds = genreIds?.ToArray();


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

                    if (movie.PhotoId != null)
                    {
                        upsertDto.PhotoId = (int)movie!.PhotoId;
                    }
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

        [HttpGet("Recommendation/{userId}")]
        public async Task<IActionResult> Recommendation(int userId, CancellationToken cancellationToken = default)
        {
            try
            {
                var recommendations = await Service.Recommendation(userId, cancellationToken);

                return Ok(recommendations);
            }
            catch (Exception e)
                {
                Logger.LogError(e, "Error while trying to get movies!");
                return BadRequest();
            }
        }
    }
}
