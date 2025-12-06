using AutoMapper;
using Microsoft.AspNetCore.Mvc;

using eCinema.Core;
using eCinema.Application.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using eCinema.Core.Dtos.Photo;
using eCinema.Core.Dtos.Employee;

namespace eCinema.Api.Controllers
{
    public class EmployeeController : BaseCrudController<EmployeeDto, EmployeeUpsertDto, EmployeeSearchObject, IEmployeesService>
    {
        private readonly IPhotosService _photosService;
        private readonly IMapper _mapper;

        public EmployeeController(IMapper mapper, IEmployeesService service, IPhotosService photosService, ILogger<EmployeeController> logger) : base(service, logger)
        {
            _mapper = mapper;
            _photosService = photosService;
        }

        [HttpPost("insertEmployee")]
        public async Task<IActionResult> Post([FromForm] EmployeeUpsertModel model, CancellationToken cancellationToken = default)
        {
            try
            {
                var upsertDto = _mapper.Map<EmployeeUpsertDto>(model);

                if (model.ProfilePhoto != null && model.ProfilePhoto.Length > 0)
                {
                    var formFile = model.ProfilePhoto;
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

                        upsertDto.ProfilePhotoId = photoId;
                    }
                }

                var user = await Service.AddAsync(upsertDto, cancellationToken);

                return Ok(user);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to add a user");
                return BadRequest();
            }
        }

        [HttpPut("updateEmployee")]
        public async Task<IActionResult> Put([FromForm] EmployeeUpsertModel model, CancellationToken cancellationToken = default)
        {
            try
            {
                var upsertDto = _mapper.Map<EmployeeUpsertDto>(model);

                if (model.ProfilePhoto != null && model.ProfilePhoto.Length > 0)
                {
                    var formFile = model.ProfilePhoto;
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

                        upsertDto.ProfilePhotoId = photoId;
                    }
                }
                else
                {

                    var user = await Service.GetByIdAsync(model.Id, cancellationToken);

                    if (user?.ProfilePhotoId != null)
                    {
                        upsertDto.ProfilePhotoId = (int)user!.ProfilePhotoId;
                    }
                }

                await Service.UpdateAsync(upsertDto, cancellationToken);

                return Ok(upsertDto);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while trying to get top users");
                return BadRequest();
            }
        }
    }
}
